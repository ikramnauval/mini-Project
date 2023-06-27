create table users.business_entity(
entity_id serial primary key
)

create table users.users(
user_entity_id serial primary key
)

create table payment.bank(
bank_entity_id integer primary key references users.business_entity(entity_id),	
bank_code varchar(10) unique,
bank_name varchar(55) unique,
bank_modified_date timestamptz default now()
)

create table payment.fintech(
fint_entity_id integer primary key references users.business_entity(entity_id),
fint_code varchar(10) unique,
fint_name varchar(55) unique,
fint_modified_date timestamptz default now()
)

select * from payment.UsersAccount

create table payment.users_account(
usac_bank_entity_id integer references payment.bank(bank_entity_id),
usac_user_entity_id integer references users.users(user_entity_id),
usac_fint_entity_id integer references payment.fintech(fint_entity_id),
usac_account_number varchar(25) unique,
usac_saldo numeric,
usac_type varchar(15) CHECK (usac_type in('debet','credit card','payment')),
usac_start_date date,
usac_end_date date,
usac_modified_date timestamptz default now(),
usac_status varchar(15) CHECK (usac_status in('active','inactive','blokir'))
)

create table payment.transaction_payment(
trpa_id serial primary key,
trpa_code_number varchar(55) unique,
trpa_order_number varchar(25),
trpa_debet numeric,
trpa_credit numeric,
trpa_type varchar (15) CHECK (trpa_type in('topup','transfer','order','refund')),
trpa_note varchar(255),
trpa_modified_date timestamptz default now(),
trpa_source_id varchar (25) NOT NULL,
trpa_target_id varchar (25) NOT NULL,
trpa_user_entity_id integer references users.users(user_entity_id)
)

UPDATE payment.transaction_payment AS tp
SET trpa_source_id = ua_source.usac_account_number,
    trpa_target_id = ua_target.usac_account_number
FROM payment.users_account AS ua_source, payment.users_account AS ua_target
WHERE tp.trpa_source_id = ua_source.usac_user_entity_id::varchar
  AND tp.trpa_target_id = ua_target.usac_user_entity_id::varchar;


--create procedure agar entity_id ny,nambah secara otomatis
CREATE OR REPLACE PROCEDURE payment.insertbank(In data JSON)
LANGUAGE plpgsql
AS $$
DECLARE 
    new_bank_entity_id INT;
BEGIN
    INSERT INTO payment.bank (bank_entity_id, bank_code, bank_name)
    SELECT entity_id, bank_code, bank_name
    FROM (
        SELECT COALESCE(MAX(bank_entity_id), 0) + 1 AS entity_id
        FROM payment.bank
    ) AS bank_id,
    json_to_recordset(data) bank (bank_code VARCHAR, bank_name VARCHAR);

    GET DIAGNOSTICS new_bank_entity_id = ROW_COUNT;

    RAISE NOTICE 'Inserted % bank entities.', new_bank_entity_id;
END $$;

--create procedure agar entity_id nya,nambah secara otomatsi
CREATE OR REPLACE PROCEDURE payment.insertfintech(In data JSON)
LANGUAGE plpgsql
AS $$
DECLARE 
    new_fint_entity_id INT;
BEGIN
    INSERT INTO payment.fintech (fint_entity_id, fint_code, fint_name)
    SELECT entity_id, fint_code, fint_name
    FROM (
        SELECT COALESCE(MAX(fint_entity_id), 0) + 1 AS entity_id
        FROM payment.fintech
    ) AS fint_id,
    json_to_recordset(data) fintech (fint_code VARCHAR, fint_name VARCHAR);

    GET DIAGNOSTICS new_fint_entity_id = ROW_COUNT;

    RAISE NOTICE 'Inserted % fintech entities.', new_fint_entity_id;
END $$;


--create procedure agar mendapatkan bank_name dari bank atau fintech
CREATE OR REPLACE PROCEDURE payment.createUserAccountWEntity(
    IN user_entity_id INT,
    IN usac_account_number VARCHAR(25),
    IN usac_saldo NUMERIC,
    IN usac_type VARCHAR(15),
    IN bank_name_input VARCHAR(55)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_bank_entity_id INT;
    v_fint_entity_id INT;
BEGIN
    -- Check if user_entity_id already has a bank account
    SELECT usac_bank_entity_id
    INTO v_bank_entity_id
    FROM payment.users_account
    WHERE usac_user_entity_id = user_entity_id
    AND usac_bank_entity_id IS NOT NULL;

    -- Check if user_entity_id already has a fintech account
    SELECT usac_fint_entity_id
    INTO v_fint_entity_id
    FROM payment.users_account
    WHERE usac_user_entity_id = user_entity_id
    AND usac_fint_entity_id IS NOT NULL;

    IF v_bank_entity_id IS NOT NULL AND v_fint_entity_id IS NOT NULL THEN
        -- User already has both a bank and fintech account, raise an exception or handle it as per your requirement
        RAISE EXCEPTION 'User already has both a bank and fintech account';
    END IF;

    IF usac_type = 'debet' OR usac_type = 'credit card' THEN
        IF v_bank_entity_id IS NOT NULL THEN
            -- User already has a bank account, raise an exception or handle it as per your requirement
            RAISE EXCEPTION 'User already has a bank account';
        ELSE
            SELECT bank_entity_id INTO v_bank_entity_id FROM payment.bank WHERE bank_name = bank_name_input;
            IF v_bank_entity_id IS NULL THEN
                -- Handle invalid bank name
                RAISE EXCEPTION 'Invalid bank name';
            END IF;
            INSERT INTO payment.users_account (usac_bank_entity_id, usac_user_entity_id, usac_account_number, usac_saldo, usac_type)
            VALUES (v_bank_entity_id, user_entity_id, usac_account_number, usac_saldo, usac_type);
        END IF;
    ELSIF usac_type = 'payment' THEN
        IF v_fint_entity_id IS NOT NULL THEN
            -- User already has a fintech account, raise an exception or handle it as per your requirement
            RAISE EXCEPTION 'User already has a fintech account';
        ELSE
            SELECT fint_entity_id INTO v_fint_entity_id FROM payment.fintech WHERE fint_name = bank_name_input;
            IF v_fint_entity_id IS NULL THEN
                -- Handle invalid fintech name
                RAISE EXCEPTION 'Invalid fintech name';
            END IF;
            INSERT INTO payment.users_account (usac_fint_entity_id, usac_user_entity_id, usac_account_number, usac_saldo, usac_type)
            VALUES (v_fint_entity_id, user_entity_id, usac_account_number, usac_saldo, usac_type);
        END IF;
    ELSE
        -- Handle invalid entity type
        RAISE EXCEPTION 'Invalid entity type';
    END IF;

    COMMIT;
END $$;


--create procedure agar update type dan bank_name ny dapat diganti
CREATE OR REPLACE PROCEDURE payment.updateUserAccountWEntity(
    IN user_entity_id INT,
    IN usac_account_number_param VARCHAR(25),
    IN usac_saldo_param NUMERIC,
    IN usac_type_param VARCHAR(15),
    IN bank_name_param VARCHAR(55)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_bank_entity_id INT;
    v_fint_entity_id INT;
    v_existing_account_count INT;
BEGIN
    -- Check if user_entity_id has a bank account
    SELECT usac_bank_entity_id
    INTO v_bank_entity_id
    FROM payment.users_account
    WHERE usac_user_entity_id = user_entity_id
    AND usac_bank_entity_id IS NOT NULL;

    -- Check if user_entity_id has a fintech account
    SELECT usac_fint_entity_id
    INTO v_fint_entity_id
    FROM payment.users_account
    WHERE usac_user_entity_id = user_entity_id
    AND usac_fint_entity_id IS NOT NULL;

    IF v_bank_entity_id IS NULL AND v_fint_entity_id IS NULL THEN
        -- User doesn't have both a bank and fintech account, raise an exception or handle it as per your requirement
        RAISE EXCEPTION 'User doesn''t have a bank or fintech account';
    END IF;

    IF usac_type_param = 'debit' OR usac_type_param = 'credit card' THEN
        SELECT bank_entity_id INTO v_bank_entity_id FROM payment.bank WHERE bank_name = bank_name_param;
        IF v_bank_entity_id IS NULL THEN
            -- Handle invalid bank name
            RAISE EXCEPTION 'Invalid bank name';
        END IF;

        -- Check if the account number already exists for another user
        SELECT COUNT(*)
        INTO v_existing_account_count
        FROM payment.users_account
        WHERE usac_account_number = usac_account_number_param
        AND usac_user_entity_id <> user_entity_id;

        IF v_existing_account_count > 0 THEN
            -- Handle duplicate account number
            RAISE EXCEPTION 'Duplicate account number';
        END IF;

        UPDATE payment.users_account
        SET
            usac_bank_entity_id = v_bank_entity_id,
            usac_account_number = usac_account_number_param,
            usac_saldo = usac_saldo_param,
            usac_type = usac_type_param
        WHERE usac_user_entity_id = user_entity_id;
    ELSIF usac_type_param = 'payment' THEN
        SELECT fint_entity_id INTO v_fint_entity_id FROM payment.fintech WHERE fint_name = bank_name_param;
        IF v_fint_entity_id IS NULL THEN
            -- Handle invalid fintech name
            RAISE EXCEPTION 'Invalid fintech name';
        END IF;

        -- Check if the account number already exists for another user
        SELECT COUNT(*)
        INTO v_existing_account_count
        FROM payment.users_account
        WHERE usac_account_number = usac_account_number_param
        AND usac_user_entity_id <> user_entity_id;

        IF v_existing_account_count > 0 THEN
            -- Handle duplicate account number
            RAISE EXCEPTION 'Duplicate account number';
        END IF;

        UPDATE payment.users_account
        SET
            usac_fint_entity_id = v_fint_entity_id,
            usac_account_number = usac_account_number_param,
            usac_saldo = usac_saldo_param,
            usac_type = usac_type_param
        WHERE usac_user_entity_id = user_entity_id;
    ELSE
        -- Handle invalid entity type
        RAISE EXCEPTION 'Invalid entity type';
    END IF;

    COMMIT;
END $$;



--create procedure,agar TRX number dengan date now 
CREATE OR REPLACE FUNCTION payment.generate_transaction_code() RETURNS VARCHAR(50)
AS $$
DECLARE
    dateNow VARCHAR(10);
    lastTransactionCode VARCHAR(50);
    lastSerialNumber INT;
    paddedSerialNumber VARCHAR(4);
    transactionCode VARCHAR(50);
BEGIN
    dateNow := to_char(CURRENT_DATE, 'YYYYMMDD');

    SELECT trpa_code_number INTO lastTransactionCode
    FROM payment.transaction_payment
    ORDER BY trpa_code_number DESC
    LIMIT 1;

    lastSerialNumber := 1;
    IF lastTransactionCode IS NOT NULL THEN
        lastSerialNumber := CAST(SUBSTRING(lastTransactionCode FROM '[0-9]+$') AS INTEGER) + 1;
    END IF;

    paddedSerialNumber := LPAD(CAST(lastSerialNumber AS VARCHAR), 4, '0');
    transactionCode := 'TRX#' || dateNow || '-' || paddedSerialNumber;

    RETURN transactionCode;
END;
$$ LANGUAGE plpgsql;


--create procedure,agar saldo dari users account dari bank nya,bisa di transfer ke fintech
CREATE OR REPLACE PROCEDURE payment.Topup(
    IN p_usac_account_number_bank VARCHAR(25),
    IN p_usac_account_number_fintech VARCHAR(25),
    IN p_credit numeric
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_bank_entity_id integer;
    v_user_entity_id integer;
    v_fint_entity_id integer;
    v_bank_saldo numeric;
    v_fint_saldo numeric;
    v_trpa_code_number varchar(50);
    v_trpa_type varchar(15) := 'topup'; -- Nilai otomatis untuk tipe transaksi
BEGIN
    -- Mendapatkan informasi bank dari usac_account_number_bank
    SELECT usac_bank_entity_id, usac_user_entity_id, usac_saldo,
           usac_user_entity_id AS v_user_entity_id
    INTO v_bank_entity_id, v_user_entity_id, v_bank_saldo
    FROM payment.users_account
    WHERE usac_account_number = p_usac_account_number_bank;

    -- Mengecek apakah saldo mencukupi
    IF v_bank_saldo < p_credit THEN
        RAISE EXCEPTION 'Saldo tidak mencukupi';
    END IF;

    -- Mendapatkan kode transaksi menggunakan fungsi payment.generate_transaction_code()
    SELECT payment.generate_transaction_code()
    INTO v_trpa_code_number;

    SELECT usac_user_entity_id, usac_fint_entity_id
    INTO v_user_entity_id, v_fint_entity_id
    FROM payment.users_account
    WHERE usac_account_number = p_usac_account_number_fintech;

    -- Mendapatkan saldo bank sebelum transaksi
    SELECT usac_saldo INTO v_bank_saldo
    FROM payment.users_account
    WHERE usac_account_number = p_usac_account_number_bank;

    -- Mengupdate nilai trpa_debet dengan saldo bank sebelum transaksi
    v_bank_saldo := v_bank_saldo - p_credit;

    -- Memasukkan data transaksi ke dalam tabel payment.transaction_payment
    INSERT INTO payment.transaction_payment (trpa_code_number, trpa_debet, trpa_credit, trpa_type, trpa_source_id, trpa_target_id, trpa_user_entity_id)
    VALUES (v_trpa_code_number, v_bank_saldo, p_credit, v_trpa_type, p_usac_account_number_bank, p_usac_account_number_fintech, v_user_entity_id);

    -- Memperbarui saldo bank
    UPDATE payment.users_account
    SET usac_saldo = usac_saldo - p_credit,
        usac_modified_date = now()
    WHERE usac_account_number = p_usac_account_number_bank
    RETURNING usac_saldo INTO v_bank_saldo;

    -- Memperbarui saldo fintech
    UPDATE payment.users_account
    SET usac_saldo = usac_saldo + p_credit,
        usac_modified_date = now()
    WHERE usac_account_number = p_usac_account_number_fintech
    RETURNING usac_saldo INTO v_fint_saldo;

    -- Jika bank entity ID dan fintech entity ID berbeda, maka perlu dilakukan transfer antar bank
    IF v_bank_entity_id != v_fint_entity_id THEN
        -- Perbarui saldo bank fintech
        UPDATE payment.users_account
        SET usac_saldo = usac_saldo - p_credit,
            usac_modified_date = now()
        WHERE usac_account_number = p_usac_account_number_bank
        AND usac_bank_entity_id = v_bank_entity_id
        RETURNING usac_saldo INTO v_bank_saldo;

        -- Perbarui saldo fintech
        UPDATE payment.users_account
        SET usac_saldo = usac_saldo + p_credit,
            usac_modified_date = now()
        WHERE usac_account_number = p_usac_account_number_fintech
        AND usac_bank_entity_id = v_fint_entity_id
        RETURNING usac_saldo INTO v_fint_saldo;
    END IF;

    -- Insert bank account record if it doesn't exist
    INSERT INTO payment.users_account (usac_bank_entity_id, usac_user_entity_id, usac_account_number, usac_saldo, usac_type, usac_status)
    SELECT v_bank_entity_id, v_user_entity_id, p_usac_account_number_bank, v_bank_saldo - p_credit, 'debet', 'active'
    WHERE NOT EXISTS (
        SELECT 1
        FROM payment.users_account
        WHERE usac_account_number = p_usac_account_number_bank
    );

    -- Insert fintech account record if it doesn't exist
    INSERT INTO payment.users_account (usac_bank_entity_id, usac_user_entity_id, usac_account_number, usac_saldo, usac_type, usac_status)
    SELECT v_fint_entity_id, v_user_entity_id, p_usac_account_number_fintech, v_fint_saldo + p_credit, 'kredit', 'active'
    WHERE NOT EXISTS (
        SELECT 1
        FROM payment.users_account
        WHERE usac_account_number = p_usac_account_number_fintech
    );

    -- Mengembalikan kode transaksi
    PERFORM v_trpa_code_number;
END;
$$;


CREATE OR REPLACE VIEW payment.UsersAccount AS
SELECT
  ua.usac_user_entity_id,
  ua.usac_account_number,
  f.fint_name AS account_name,
  ua.usac_saldo AS balance,
  ua.usac_type
FROM
  payment.users_account ua
JOIN
  payment.fintech f ON ua.usac_fint_entity_id = f.fint_entity_id
UNION ALL
SELECT
  ua.usac_user_entity_id,
  ua.usac_account_number,
  b.bank_name AS account_name,
  ua.usac_saldo AS balance,
  ua.usac_type
FROM
  payment.users_account ua
JOIN
  payment.bank b ON ua.usac_bank_entity_id = b.bank_entity_id;



CREATE OR REPLACE VIEW payment.transaction_history AS
SELECT
    trpa_code_number,
    trpa_modified_date,
    trpa_debet,
    trpa_credit,
    trpa_note,
    trpa_source_id,
    trpa_target_id,
    trpa_type,
    CONCAT(u.user_first_name, ' ', u.user_last_name) AS User
FROM
    payment.transaction_payment tp
JOIN
    users.users u ON tp.trpa_user_entity_id = u.user_entity_id;

