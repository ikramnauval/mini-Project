--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bootcamp; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA bootcamp;


ALTER SCHEMA bootcamp OWNER TO postgres;

--
-- Name: curriculum; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA curriculum;


ALTER SCHEMA curriculum OWNER TO postgres;

--
-- Name: hr; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hr;


ALTER SCHEMA hr OWNER TO postgres;

--
-- Name: job_hire; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA job_hire;


ALTER SCHEMA job_hire OWNER TO postgres;

--
-- Name: master; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA master;


ALTER SCHEMA master OWNER TO postgres;

--
-- Name: payment; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA payment;


ALTER SCHEMA payment OWNER TO postgres;

--
-- Name: sales; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sales;


ALTER SCHEMA sales OWNER TO postgres;

--
-- Name: users; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA users;


ALTER SCHEMA users OWNER TO postgres;

--
-- Name: roac_display; Type: TYPE; Schema: master; Owner: postgres
--

CREATE TYPE master.roac_display AS ENUM (
    '0',
    '1'
);


ALTER TYPE master.roac_display OWNER TO postgres;

--
-- Name: closebatch(json, json); Type: PROCEDURE; Schema: bootcamp; Owner: postgres
--

CREATE PROCEDURE bootcamp.closebatch(IN data json, IN data2 json)
    LANGUAGE plpgsql
    AS $$
declare
	data_store record;
begin
	select * from json_to_recordset(data) as x(
		batch_id int,
		batch_status varchar(15)
	)
	into data_store;
	
	update bootcamp.batch set
		batch_status= data_store.batch_status
	where batch_id = data_store.batch_id;
	
	insert into bootcamp.talents(
		talent_fullname,
		talent_user_entity_id,
		talent_technology,
		talent_batch_id,
		talent_status,
		talent_skill
	)
	select
		y.talent_fullname,
		y.talent_user_entity_id,
		y.talent_technology,
		data_store.batch_id,
		y.talent_status,
		y.talent_skill
	from json_to_recordset(data2) as y(
		talent_fullname varchar(100),
		talent_user_entity_id integer,
		talent_technology varchar(50),
		talent_status varchar(15),
		talent_skill varchar(256)
	);

end;
$$;


ALTER PROCEDURE bootcamp.closebatch(IN data json, IN data2 json) OWNER TO postgres;

--
-- Name: createevaluation(integer, json); Type: PROCEDURE; Schema: bootcamp; Owner: postgres
--

CREATE PROCEDURE bootcamp.createevaluation(IN totalscore integer, IN data2 json)
    LANGUAGE plpgsql
    AS $$
declare
	trainee_entity_id int;
	batch_id int;
begin
	with result as (
	insert into bootcamp.batch_trainee_evaluation(
		btev_type,
		btev_header,
		btev_section,
		btev_skill,
		btev_week,
		btev_skor,
		btev_note,
		btev_modified_date,
		btev_batch_id,
		btev_trainee_entity_id
	)
	select 
		x.btev_type,
		x.btev_header,
		x.btev_section,
		x.btev_skill,
		x.btev_week,
		x.btev_skor,
		x.btev_note,
		x.btev_modified_date,
		x.btev_batch_id,
		x.btev_trainee_entity_id
	from json_to_recordset(data2) as x(
		btev_type varchar(15),
		btev_header varchar(256),
		btev_section varchar(256),
		btev_skill varchar(256),
		btev_week int,
		btev_skor int,
		btev_note varchar(256),
		btev_modified_date timestamptz,
		btev_batch_id int,
		btev_trainee_entity_id int
	) 
	returning btev_batch_id,btev_trainee_entity_id 
	)
	select btev_batch_id,btev_trainee_entity_id 
	into batch_id,trainee_entity_id from result;
	
	update bootcamp.batch_trainee set batr_total_score = totalscore
	where batr_trainee_entity_id = trainee_entity_id
	and batr_batch_id = batch_id;
end;
$$;


ALTER PROCEDURE bootcamp.createevaluation(IN totalscore integer, IN data2 json) OWNER TO postgres;

--
-- Name: createprogramapply(json, json); Type: PROCEDURE; Schema: bootcamp; Owner: postgres
--

CREATE PROCEDURE bootcamp.createprogramapply(IN data json, IN data2 json)
    LANGUAGE plpgsql
    AS $$
declare
	userEntityId int;
	progEntityId int;
	
begin
	with result as(
	insert into bootcamp.program_apply(
		prap_user_entity_id,
		prap_prog_entity_id,
		prap_test_score,
		prap_gpa,
		prap_iq_test,
		prap_review,
		prap_modified_date,
		prap_status
	)
	select
		x.prap_user_entity_id,
		x.prap_prog_entity_id,
		x.prap_test_score,
		x.prap_gpa,
		x.prap_iq_test,
		x.prap_review,
		x.prap_modified_date,
		x.prap_status
	
	from json_to_recordset(data) as x(
		prap_user_entity_id int,
		prap_prog_entity_id int,
		prap_test_score int,
		prap_gpa numeric,
		prap_iq_test numeric,
		prap_review varchar(256) ,
		prap_modified_date TIMESTAMPTZ,
		prap_status VARCHAR(15)
	)
	returning prap_user_entity_id,prap_prog_entity_id
	)
	select prap_user_entity_id,prap_prog_entity_id into userEntityId,progEntityId from result;
	
	insert into bootcamp.program_apply_progress(
		parog_user_entity_id,
		parog_prog_entity_id,
		parog_action_date,
		parog_modified_date,
		parog_comment,
		parog_progress_name,
		parog_emp_entity_id,
		parog_status
	)
	select
		userEntityId,
		progEntityId,
		y.parog_action_date,
		y.parog_modified_date,
		y.parog_comment,
		y.parog_progress_name,
		y.parog_emp_entity_id,
		y.parog_status
		
	from json_to_recordset(data2) as y(
		parog_action_date TIMESTAMPTZ,
		parog_modified_date TIMESTAMPTZ,
		parog_comment VARCHAR(512),
		parog_progress_name VARCHAR(15),
		parog_emp_entity_id INT,
		parog_status VARCHAR(15)
	);

end;
$$;


ALTER PROCEDURE bootcamp.createprogramapply(IN data json, IN data2 json) OWNER TO postgres;

--
-- Name: spaccountnumber(json, json, character varying); Type: PROCEDURE; Schema: payment; Owner: postgres
--

CREATE PROCEDURE payment.spaccountnumber(IN data1 json, IN data2 json, IN trpa_target_id character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_UserAccountNumber int;
    new_TransactionPaymentId int;
    source_account_number varchar(25);
    target_account_number varchar(25);
BEGIN
    WITH trpa_user_entity AS (
        INSERT INTO payment.transaction_payment(trpa_user_entity_id, trpa_source_id, trpa_target_id)
        SELECT x.trpa_user_entity_id, x.trpa_source_id, trpa_target_id
        FROM json_to_recordset(data1) x (trpa_user_entity_id int, trpa_source_id varchar)
        RETURNING trpa_id
    )
    SELECT trpa_id INTO new_TransactionPaymentId FROM trpa_user_entity;
    
    SELECT x.usac_account_number INTO source_account_number
    FROM json_to_recordset(data2) x (usac_user_entity_id int, usac_account_number varchar)
    WHERE x.usac_user_entity_id = new_TransactionPaymentId;
    
    INSERT INTO payment.users_account(usac_user_entity_id, usac_account_number)
    SELECT new_TransactionPaymentId, source_account_number;
    
    INSERT INTO payment.transaction_payment(trpa_source_id, trpa_target_id, trpa_debet, trpa_type, trpa_modified_date)
    SELECT tp.trpa_source_id, tp.trpa_target_id, tp.trpa_debet, 'transfer', now()
    FROM payment.transaction_payment tp
    WHERE tp.trpa_id = new_TransactionPaymentId;
    
    UPDATE payment.transaction_payment
    SET trpa_credit = trpa_credit - (SELECT trpa_debet FROM payment.transaction_payment WHERE trpa_id = new_TransactionPaymentId)
    WHERE trpa_id = new_TransactionPaymentId;
    
    SELECT ua.usac_account_number INTO target_account_number
    FROM payment.transaction_payment tp
    JOIN payment.users_account ua ON ua.usac_user_entity_id = tp.trpa_target_id
    WHERE tp.trpa_id = new_TransactionPaymentId;
    
    UPDATE payment.transaction_payment
    SET trpa_credit = trpa_credit + (SELECT trpa_debet FROM payment.transaction_payment WHERE trpa_id = new_TransactionPaymentId)
    WHERE trpa_id = trpa_target_id;  
END;
$$;


ALTER PROCEDURE payment.spaccountnumber(IN data1 json, IN data2 json, IN trpa_target_id character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: batch; Type: TABLE; Schema: bootcamp; Owner: postgres
--

CREATE TABLE bootcamp.batch (
    batch_id integer NOT NULL,
    batch_entity_id integer NOT NULL,
    batch_name character varying(15),
    batch_description character varying(125),
    batch_start_date date,
    batch_end_date date,
    batch_reason character varying(256),
    batch_type character varying(15),
    batch_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    batch_status character varying(15),
    batch_pic_id integer,
    CONSTRAINT batch_batch_status_check CHECK (((batch_status)::text = ANY ((ARRAY['open'::character varying, 'running'::character varying, 'closed'::character varying, 'pending'::character varying, 'cancelled'::character varying, 'extend'::character varying])::text[])))
);


ALTER TABLE bootcamp.batch OWNER TO postgres;

--
-- Name: batch_batch_id_seq; Type: SEQUENCE; Schema: bootcamp; Owner: postgres
--

CREATE SEQUENCE bootcamp.batch_batch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bootcamp.batch_batch_id_seq OWNER TO postgres;

--
-- Name: batch_batch_id_seq; Type: SEQUENCE OWNED BY; Schema: bootcamp; Owner: postgres
--

ALTER SEQUENCE bootcamp.batch_batch_id_seq OWNED BY bootcamp.batch.batch_id;


--
-- Name: batch_trainee; Type: TABLE; Schema: bootcamp; Owner: postgres
--

CREATE TABLE bootcamp.batch_trainee (
    batr_id integer NOT NULL,
    batr_status character varying(15),
    batr_certificated character(1),
    batr_certificate_link character varying(255),
    batr_access_token character varying(255),
    batr_access_grant character(1),
    batr_review character varying(1024),
    batr_total_score numeric,
    batr_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    batr_trainee_entity_id integer,
    batr_batch_id integer NOT NULL,
    CONSTRAINT batch_trainee_batr_access_grant_check CHECK ((batr_access_grant = ANY (ARRAY['0'::bpchar, '1'::bpchar]))),
    CONSTRAINT batch_trainee_batr_certificated_check CHECK ((batr_certificated = ANY (ARRAY['0'::bpchar, '1'::bpchar]))),
    CONSTRAINT batch_trainee_batr_status_check CHECK (((batr_status)::text = ANY ((ARRAY['passed'::character varying, 'failed'::character varying, 'resign'::character varying, 'running'::character varying])::text[])))
);


ALTER TABLE bootcamp.batch_trainee OWNER TO postgres;

--
-- Name: batch_trainee_batr_id_seq; Type: SEQUENCE; Schema: bootcamp; Owner: postgres
--

CREATE SEQUENCE bootcamp.batch_trainee_batr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bootcamp.batch_trainee_batr_id_seq OWNER TO postgres;

--
-- Name: batch_trainee_batr_id_seq; Type: SEQUENCE OWNED BY; Schema: bootcamp; Owner: postgres
--

ALTER SEQUENCE bootcamp.batch_trainee_batr_id_seq OWNED BY bootcamp.batch_trainee.batr_id;


--
-- Name: batch_trainee_evaluation; Type: TABLE; Schema: bootcamp; Owner: postgres
--

CREATE TABLE bootcamp.batch_trainee_evaluation (
    btev_id integer NOT NULL,
    btev_type character varying(15),
    btev_header character varying(256),
    btev_section character varying(256),
    btev_skill character varying(256),
    btev_week integer,
    btev_skor integer,
    btev_note character varying(256),
    btev_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    btev_batch_id integer,
    btev_trainee_entity_id integer,
    CONSTRAINT batch_trainee_evaluation_btev_type_check CHECK (((btev_type)::text = ANY ((ARRAY['hardskill'::character varying, 'softskill'::character varying])::text[])))
);


ALTER TABLE bootcamp.batch_trainee_evaluation OWNER TO postgres;

--
-- Name: batch_trainee_evaluation_btev_id_seq; Type: SEQUENCE; Schema: bootcamp; Owner: postgres
--

CREATE SEQUENCE bootcamp.batch_trainee_evaluation_btev_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bootcamp.batch_trainee_evaluation_btev_id_seq OWNER TO postgres;

--
-- Name: batch_trainee_evaluation_btev_id_seq; Type: SEQUENCE OWNED BY; Schema: bootcamp; Owner: postgres
--

ALTER SEQUENCE bootcamp.batch_trainee_evaluation_btev_id_seq OWNED BY bootcamp.batch_trainee_evaluation.btev_id;


--
-- Name: instructor_programs; Type: TABLE; Schema: bootcamp; Owner: postgres
--

CREATE TABLE bootcamp.instructor_programs (
    inpro_batch_id integer NOT NULL,
    inpro_entity_id integer NOT NULL,
    inpro_emp_entity_id integer NOT NULL,
    inpro_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE bootcamp.instructor_programs OWNER TO postgres;

--
-- Name: program_apply; Type: TABLE; Schema: bootcamp; Owner: postgres
--

CREATE TABLE bootcamp.program_apply (
    prap_user_entity_id integer NOT NULL,
    prap_prog_entity_id integer NOT NULL,
    prap_test_score integer,
    prap_gpa numeric,
    prap_iq_test numeric,
    prap_review character varying(256),
    prap_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    prap_status character varying(15),
    CONSTRAINT program_apply_prap_status_check CHECK (((prap_status)::text = ANY ((ARRAY['recommendation'::character varying, 'passed'::character varying, 'failed'::character varying])::text[])))
);


ALTER TABLE bootcamp.program_apply OWNER TO postgres;

--
-- Name: program_apply_progress; Type: TABLE; Schema: bootcamp; Owner: postgres
--

CREATE TABLE bootcamp.program_apply_progress (
    parog_id integer NOT NULL,
    parog_user_entity_id integer,
    parog_prog_entity_id integer,
    parog_action_date timestamp with time zone,
    parog_modified_date timestamp with time zone,
    parog_comment character varying(512),
    parog_progress_name character varying(15),
    parog_emp_entity_id integer,
    parog_status character varying(15),
    CONSTRAINT program_apply_progress_parog_progress_name_check CHECK (((parog_progress_name)::text = ANY ((ARRAY['apply'::character varying, 'filtering test'::character varying, 'failed'::character varying, 'contract'::character varying, 'disqualified'::character varying, 'not responding'::character varying])::text[]))),
    CONSTRAINT program_apply_progress_parog_status_check CHECK (((parog_status)::text = ANY ((ARRAY['open'::character varying, 'wait'::character varying, 'cancelled'::character varying, 'closed'::character varying])::text[])))
);


ALTER TABLE bootcamp.program_apply_progress OWNER TO postgres;

--
-- Name: program_apply_progress_parog_id_seq; Type: SEQUENCE; Schema: bootcamp; Owner: postgres
--

CREATE SEQUENCE bootcamp.program_apply_progress_parog_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bootcamp.program_apply_progress_parog_id_seq OWNER TO postgres;

--
-- Name: program_apply_progress_parog_id_seq; Type: SEQUENCE OWNED BY; Schema: bootcamp; Owner: postgres
--

ALTER SEQUENCE bootcamp.program_apply_progress_parog_id_seq OWNED BY bootcamp.program_apply_progress.parog_id;


--
-- Name: talents; Type: TABLE; Schema: bootcamp; Owner: postgres
--

CREATE TABLE bootcamp.talents (
    talent_id integer NOT NULL,
    talent_fullname character varying(100),
    talent_user_entity_id integer,
    talent_technology character varying(50),
    talent_batch_id integer,
    talent_status character varying(15),
    talent_skill character varying(256)
);


ALTER TABLE bootcamp.talents OWNER TO postgres;

--
-- Name: talents_talent_id_seq; Type: SEQUENCE; Schema: bootcamp; Owner: postgres
--

CREATE SEQUENCE bootcamp.talents_talent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bootcamp.talents_talent_id_seq OWNER TO postgres;

--
-- Name: talents_talent_id_seq; Type: SEQUENCE OWNED BY; Schema: bootcamp; Owner: postgres
--

ALTER SEQUENCE bootcamp.talents_talent_id_seq OWNED BY bootcamp.talents.talent_id;


--
-- Name: program_entity; Type: TABLE; Schema: curriculum; Owner: postgres
--

CREATE TABLE curriculum.program_entity (
    prog_entity_id integer NOT NULL,
    prog_title character varying(256),
    prog_headline character varying(512),
    prog_type character varying(15),
    prog_learning_type character varying(15),
    prog_rating numeric,
    prog_total_trainee integer,
    prog_image character varying(256),
    prog_best_seller character(1),
    prog_price numeric,
    prog_language character varying(35),
    prog_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    prog_duration integer,
    prog_duration_type character varying(15),
    prog_tag_skill character varying(512),
    prog_city_id integer,
    prog_cate_id integer,
    prog_created_by integer,
    prog_status character varying(15),
    CONSTRAINT program_entity_prog_best_seller_check CHECK ((prog_best_seller = ANY (ARRAY['0'::bpchar, '1'::bpchar]))),
    CONSTRAINT program_entity_prog_duration_type_check CHECK (((prog_duration_type)::text = ANY ((ARRAY['month'::character varying, 'week'::character varying, 'days'::character varying])::text[]))),
    CONSTRAINT program_entity_prog_language_check CHECK (((prog_language)::text = ANY ((ARRAY['english'::character varying, 'bahasa'::character varying])::text[]))),
    CONSTRAINT program_entity_prog_learning_type_check CHECK (((prog_learning_type)::text = ANY ((ARRAY['online'::character varying, 'offline'::character varying, 'both'::character varying])::text[]))),
    CONSTRAINT program_entity_prog_status_check CHECK (((prog_status)::text = ANY ((ARRAY['draft'::character varying, 'publish'::character varying])::text[]))),
    CONSTRAINT program_entity_prog_type_check CHECK (((prog_type)::text = ANY ((ARRAY['bootcamp'::character varying, 'course'::character varying])::text[])))
);


ALTER TABLE curriculum.program_entity OWNER TO postgres;

--
-- Name: program_entity_description; Type: TABLE; Schema: curriculum; Owner: postgres
--

CREATE TABLE curriculum.program_entity_description (
    pred_prog_entity_id integer NOT NULL,
    pred_item_learning json,
    pred_item_include json,
    pred_requirement json,
    pred_description json,
    pred_target_level json
);


ALTER TABLE curriculum.program_entity_description OWNER TO postgres;

--
-- Name: program_entity_prog_entity_id_seq; Type: SEQUENCE; Schema: curriculum; Owner: postgres
--

CREATE SEQUENCE curriculum.program_entity_prog_entity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE curriculum.program_entity_prog_entity_id_seq OWNER TO postgres;

--
-- Name: program_entity_prog_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: curriculum; Owner: postgres
--

ALTER SEQUENCE curriculum.program_entity_prog_entity_id_seq OWNED BY curriculum.program_entity.prog_entity_id;


--
-- Name: program_reviews; Type: TABLE; Schema: curriculum; Owner: postgres
--

CREATE TABLE curriculum.program_reviews (
    prow_user_entity_id integer NOT NULL,
    prow_prog_entity_id integer NOT NULL,
    prow_review character varying(512),
    prow_rating integer,
    prow_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE curriculum.program_reviews OWNER TO postgres;

--
-- Name: section_detail; Type: TABLE; Schema: curriculum; Owner: postgres
--

CREATE TABLE curriculum.section_detail (
    secd_id integer NOT NULL,
    secd_title character varying(256),
    secd_preview character(1),
    secd_score integer,
    secd_note character varying(256),
    secd_minute integer,
    secd_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    secd_sect_id integer,
    CONSTRAINT section_detail_secd_preview_check CHECK ((secd_preview = ANY (ARRAY['0'::bpchar, '1'::bpchar])))
);


ALTER TABLE curriculum.section_detail OWNER TO postgres;

--
-- Name: section_detail_material; Type: TABLE; Schema: curriculum; Owner: postgres
--

CREATE TABLE curriculum.section_detail_material (
    sedm_id integer NOT NULL,
    sedm_filename character varying(55),
    sedm_filesize integer,
    sedm_filetype character varying(15),
    sedm_filelink character varying(255),
    sedm_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    sedm_secd_id integer NOT NULL,
    CONSTRAINT section_detail_material_sedm_filetype_check CHECK (((sedm_filetype)::text = ANY ((ARRAY['video'::character varying, 'image'::character varying, 'text'::character varying, 'link'::character varying])::text[])))
);


ALTER TABLE curriculum.section_detail_material OWNER TO postgres;

--
-- Name: section_detail_material_sedm_id_seq; Type: SEQUENCE; Schema: curriculum; Owner: postgres
--

CREATE SEQUENCE curriculum.section_detail_material_sedm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE curriculum.section_detail_material_sedm_id_seq OWNER TO postgres;

--
-- Name: section_detail_material_sedm_id_seq; Type: SEQUENCE OWNED BY; Schema: curriculum; Owner: postgres
--

ALTER SEQUENCE curriculum.section_detail_material_sedm_id_seq OWNED BY curriculum.section_detail_material.sedm_id;


--
-- Name: section_detail_material_sedm_secd_id_seq; Type: SEQUENCE; Schema: curriculum; Owner: postgres
--

CREATE SEQUENCE curriculum.section_detail_material_sedm_secd_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE curriculum.section_detail_material_sedm_secd_id_seq OWNER TO postgres;

--
-- Name: section_detail_material_sedm_secd_id_seq; Type: SEQUENCE OWNED BY; Schema: curriculum; Owner: postgres
--

ALTER SEQUENCE curriculum.section_detail_material_sedm_secd_id_seq OWNED BY curriculum.section_detail_material.sedm_secd_id;


--
-- Name: section_detail_secd_id_seq; Type: SEQUENCE; Schema: curriculum; Owner: postgres
--

CREATE SEQUENCE curriculum.section_detail_secd_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE curriculum.section_detail_secd_id_seq OWNER TO postgres;

--
-- Name: section_detail_secd_id_seq; Type: SEQUENCE OWNED BY; Schema: curriculum; Owner: postgres
--

ALTER SEQUENCE curriculum.section_detail_secd_id_seq OWNED BY curriculum.section_detail.secd_id;


--
-- Name: sections; Type: TABLE; Schema: curriculum; Owner: postgres
--

CREATE TABLE curriculum.sections (
    sect_id integer NOT NULL,
    sect_prog_entity_id integer NOT NULL,
    sect_title character varying(100),
    sect_description character varying(256),
    sect_total_section integer,
    sect_total_lecture integer,
    sect_total_minute integer,
    sect_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE curriculum.sections OWNER TO postgres;

--
-- Name: sections_sect_id_seq; Type: SEQUENCE; Schema: curriculum; Owner: postgres
--

CREATE SEQUENCE curriculum.sections_sect_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE curriculum.sections_sect_id_seq OWNER TO postgres;

--
-- Name: sections_sect_id_seq; Type: SEQUENCE OWNED BY; Schema: curriculum; Owner: postgres
--

ALTER SEQUENCE curriculum.sections_sect_id_seq OWNED BY curriculum.sections.sect_id;


--
-- Name: department; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.department (
    dept_id integer NOT NULL,
    dept_name character varying(50),
    dept_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE hr.department OWNER TO postgres;

--
-- Name: department_dept_id_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.department_dept_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hr.department_dept_id_seq OWNER TO postgres;

--
-- Name: department_dept_id_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.department_dept_id_seq OWNED BY hr.department.dept_id;


--
-- Name: employee; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.employee (
    emp_entity_id integer NOT NULL,
    emp_emp_number character varying(25),
    emp_national_id character varying(25),
    emp_birth_date date NOT NULL,
    emp_marital_status character(1),
    emp_gender character(1),
    emp_hire_date date,
    emp_salaried_flag character(1),
    emp_vacation_hours smallint,
    emp_sickleave_hours smallint,
    emp_current_flag smallint,
    emp_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    emp_type character varying(15),
    emp_joro_id integer,
    emp_emp_entity_id integer,
    CONSTRAINT employee_emp_current_flag_check CHECK ((emp_current_flag = ANY (ARRAY[0, 1]))),
    CONSTRAINT employee_emp_gender_check CHECK ((emp_gender = ANY (ARRAY['M'::bpchar, 'F'::bpchar]))),
    CONSTRAINT employee_emp_marital_status_check CHECK ((emp_marital_status = ANY (ARRAY['M'::bpchar, 'S'::bpchar]))),
    CONSTRAINT employee_emp_salaried_flag_check CHECK ((emp_salaried_flag = ANY (ARRAY['0'::bpchar, '1'::bpchar]))),
    CONSTRAINT employee_emp_type_check CHECK (((emp_type)::text = ANY ((ARRAY['internal'::character varying, 'outsource'::character varying])::text[])))
);


ALTER TABLE hr.employee OWNER TO postgres;

--
-- Name: employee_department_history; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.employee_department_history (
    edhi_id integer NOT NULL,
    edhi_entity_id integer NOT NULL,
    edhi_start_date date,
    edhi_end_date date,
    edhi_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    edhi_dept_id integer
);


ALTER TABLE hr.employee_department_history OWNER TO postgres;

--
-- Name: employee_department_history_edhi_id_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.employee_department_history_edhi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hr.employee_department_history_edhi_id_seq OWNER TO postgres;

--
-- Name: employee_department_history_edhi_id_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.employee_department_history_edhi_id_seq OWNED BY hr.employee_department_history.edhi_id;


--
-- Name: employee_pay_history; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.employee_pay_history (
    ephi_entity_id integer NOT NULL,
    ephi_rate_change_date date NOT NULL,
    ephi_rate_salary numeric,
    ephi_pay_frequence smallint,
    ephi_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT employee_pay_history_ephi_pay_frequence_check CHECK ((ephi_pay_frequence = ANY (ARRAY[1, 2])))
);


ALTER TABLE hr.employee_pay_history OWNER TO postgres;

--
-- Name: client; Type: TABLE; Schema: job_hire; Owner: postgres
--

CREATE TABLE job_hire.client (
    clit_id integer NOT NULL,
    clit_name character varying(256),
    clit_about character varying(512),
    clit_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    clit_addr_id integer,
    clit_emra_id integer
);


ALTER TABLE job_hire.client OWNER TO postgres;

--
-- Name: client_clit_id_seq; Type: SEQUENCE; Schema: job_hire; Owner: postgres
--

CREATE SEQUENCE job_hire.client_clit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_hire.client_clit_id_seq OWNER TO postgres;

--
-- Name: client_clit_id_seq; Type: SEQUENCE OWNED BY; Schema: job_hire; Owner: postgres
--

ALTER SEQUENCE job_hire.client_clit_id_seq OWNED BY job_hire.client.clit_id;


--
-- Name: employee_range; Type: TABLE; Schema: job_hire; Owner: postgres
--

CREATE TABLE job_hire.employee_range (
    emra_id integer NOT NULL,
    emra_range_min integer,
    emra_range_max integer,
    emra_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE job_hire.employee_range OWNER TO postgres;

--
-- Name: employee_range_emra_id_seq; Type: SEQUENCE; Schema: job_hire; Owner: postgres
--

CREATE SEQUENCE job_hire.employee_range_emra_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_hire.employee_range_emra_id_seq OWNER TO postgres;

--
-- Name: employee_range_emra_id_seq; Type: SEQUENCE OWNED BY; Schema: job_hire; Owner: postgres
--

ALTER SEQUENCE job_hire.employee_range_emra_id_seq OWNED BY job_hire.employee_range.emra_id;


--
-- Name: job_category; Type: TABLE; Schema: job_hire; Owner: postgres
--

CREATE TABLE job_hire.job_category (
    joca_id integer NOT NULL,
    joca_name character varying(255),
    joca_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE job_hire.job_category OWNER TO postgres;

--
-- Name: job_category_joca_id_seq; Type: SEQUENCE; Schema: job_hire; Owner: postgres
--

CREATE SEQUENCE job_hire.job_category_joca_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_hire.job_category_joca_id_seq OWNER TO postgres;

--
-- Name: job_category_joca_id_seq; Type: SEQUENCE OWNED BY; Schema: job_hire; Owner: postgres
--

ALTER SEQUENCE job_hire.job_category_joca_id_seq OWNED BY job_hire.job_category.joca_id;


--
-- Name: job_photo; Type: TABLE; Schema: job_hire; Owner: postgres
--

CREATE TABLE job_hire.job_photo (
    jopho_id integer NOT NULL,
    jopho_filename character varying(55),
    jopho_filesize integer,
    jopho_filetype character varying(15),
    jopho_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    jopho_entity_id integer,
    CONSTRAINT job_photo_jopho_filetype_check CHECK (((jopho_filetype)::text = ANY ((ARRAY['png'::character varying, 'jpeg'::character varying])::text[])))
);


ALTER TABLE job_hire.job_photo OWNER TO postgres;

--
-- Name: job_photo_jopho_id_seq; Type: SEQUENCE; Schema: job_hire; Owner: postgres
--

CREATE SEQUENCE job_hire.job_photo_jopho_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_hire.job_photo_jopho_id_seq OWNER TO postgres;

--
-- Name: job_photo_jopho_id_seq; Type: SEQUENCE OWNED BY; Schema: job_hire; Owner: postgres
--

ALTER SEQUENCE job_hire.job_photo_jopho_id_seq OWNED BY job_hire.job_photo.jopho_id;


--
-- Name: job_post; Type: TABLE; Schema: job_hire; Owner: postgres
--

CREATE TABLE job_hire.job_post (
    jopo_entity_id integer NOT NULL,
    jopo_number character varying(25),
    jopo_title character varying(256),
    jopo_start_date date,
    jopo_end_date date,
    jopo_min_salary numeric,
    jopo_max_salary numeric,
    jopo_min_experience integer,
    jopo_max_experience integer,
    jopo_primary_skill character varying(256),
    jopo_secondary_skill character varying(256),
    jopo_publish_date date,
    jopo_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    jopo_emp_entity_id integer,
    jopo_clit_id integer,
    jopo_joro_id integer,
    jopo_joty_id integer,
    jopo_joca_id integer,
    jopo_addr_id integer,
    jopo_work_code character varying(15),
    jopo_edu_code character varying(15),
    jopo_indu_code character varying(15),
    jopo_status character varying(15),
    CONSTRAINT job_post_jopo_status_check CHECK (((jopo_status)::text = ANY ((ARRAY['publish'::character varying, 'draft'::character varying, 'cancelled'::character varying, 'remove'::character varying])::text[])))
);


ALTER TABLE job_hire.job_post OWNER TO postgres;

--
-- Name: job_post_desc; Type: TABLE; Schema: job_hire; Owner: postgres
--

CREATE TABLE job_hire.job_post_desc (
    jopo_entity_id integer NOT NULL,
    jopo_description json,
    jopo_responsibility json,
    jopo_target json,
    jopo_benefit json
);


ALTER TABLE job_hire.job_post_desc OWNER TO postgres;

--
-- Name: job_post_jopo_entity_id_seq; Type: SEQUENCE; Schema: job_hire; Owner: postgres
--

CREATE SEQUENCE job_hire.job_post_jopo_entity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_hire.job_post_jopo_entity_id_seq OWNER TO postgres;

--
-- Name: job_post_jopo_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: job_hire; Owner: postgres
--

ALTER SEQUENCE job_hire.job_post_jopo_entity_id_seq OWNED BY job_hire.job_post.jopo_entity_id;


--
-- Name: talent_apply; Type: TABLE; Schema: job_hire; Owner: postgres
--

CREATE TABLE job_hire.talent_apply (
    taap_user_entity_id integer NOT NULL,
    taap_entity_id integer NOT NULL,
    taap_intro character varying(512),
    taap_scoring integer,
    taap_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    taap_status character varying(15),
    CONSTRAINT talent_apply_taap_status_check CHECK (((taap_status)::text = ANY ((ARRAY['interview'::character varying, 'failed'::character varying, 'succeed'::character varying])::text[])))
);


ALTER TABLE job_hire.talent_apply OWNER TO postgres;

--
-- Name: talent_apply_progress; Type: TABLE; Schema: job_hire; Owner: postgres
--

CREATE TABLE job_hire.talent_apply_progress (
    tapr_id integer NOT NULL,
    tapr_taap_user_entity_id integer NOT NULL,
    tapr_taap_entity_id integer NOT NULL,
    tapr_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    tapr_status character varying(15),
    tapr_comment character varying(256),
    tapr_progress_name character varying(55),
    CONSTRAINT talent_apply_progress_tapr_status_check CHECK (((tapr_status)::text = ANY ((ARRAY['Open'::character varying, 'Waiting'::character varying, 'Done'::character varying, 'Cancelled'::character varying, 'Closed'::character varying])::text[])))
);


ALTER TABLE job_hire.talent_apply_progress OWNER TO postgres;

--
-- Name: talent_apply_progress_tapr_id_seq; Type: SEQUENCE; Schema: job_hire; Owner: postgres
--

CREATE SEQUENCE job_hire.talent_apply_progress_tapr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_hire.talent_apply_progress_tapr_id_seq OWNER TO postgres;

--
-- Name: talent_apply_progress_tapr_id_seq; Type: SEQUENCE OWNED BY; Schema: job_hire; Owner: postgres
--

ALTER SEQUENCE job_hire.talent_apply_progress_tapr_id_seq OWNED BY job_hire.talent_apply_progress.tapr_id;


--
-- Name: address; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.address (
    addr_id integer NOT NULL,
    addr_line1 character varying(255),
    addr_line2 character varying(255),
    addr_postal_code character varying(10),
    addr_spatial_location json,
    addr_modifed_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    addr_city_id integer
);


ALTER TABLE master.address OWNER TO postgres;

--
-- Name: address_addr_id_seq; Type: SEQUENCE; Schema: master; Owner: postgres
--

CREATE SEQUENCE master.address_addr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master.address_addr_id_seq OWNER TO postgres;

--
-- Name: address_addr_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: postgres
--

ALTER SEQUENCE master.address_addr_id_seq OWNED BY master.address.addr_id;


--
-- Name: address_type; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.address_type (
    adty_id integer NOT NULL,
    adty_name character varying(15),
    adty_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master.address_type OWNER TO postgres;

--
-- Name: address_type_adty_id_seq; Type: SEQUENCE; Schema: master; Owner: postgres
--

CREATE SEQUENCE master.address_type_adty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master.address_type_adty_id_seq OWNER TO postgres;

--
-- Name: address_type_adty_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: postgres
--

ALTER SEQUENCE master.address_type_adty_id_seq OWNED BY master.address_type.adty_id;


--
-- Name: category; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.category (
    cate_id integer NOT NULL,
    cate_name character varying(255),
    cate_cate_id integer,
    cate_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master.category OWNER TO postgres;

--
-- Name: category_cate_id_seq; Type: SEQUENCE; Schema: master; Owner: postgres
--

CREATE SEQUENCE master.category_cate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master.category_cate_id_seq OWNER TO postgres;

--
-- Name: category_cate_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: postgres
--

ALTER SEQUENCE master.category_cate_id_seq OWNED BY master.category.cate_id;


--
-- Name: city; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.city (
    city_id integer NOT NULL,
    city_name character varying(155),
    city_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    city_prov_id integer
);


ALTER TABLE master.city OWNER TO postgres;

--
-- Name: city_city_id_seq; Type: SEQUENCE; Schema: master; Owner: postgres
--

CREATE SEQUENCE master.city_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master.city_city_id_seq OWNER TO postgres;

--
-- Name: city_city_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: postgres
--

ALTER SEQUENCE master.city_city_id_seq OWNED BY master.city.city_id;


--
-- Name: country; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.country (
    country_code character varying(3) NOT NULL,
    country_name character varying(85),
    country_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master.country OWNER TO postgres;

--
-- Name: education; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.education (
    edu_code character varying(5) NOT NULL,
    edu_name character varying(55)
);


ALTER TABLE master.education OWNER TO postgres;

--
-- Name: industry; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.industry (
    indu_code character varying(5) NOT NULL,
    indu_name character varying(85)
);


ALTER TABLE master.industry OWNER TO postgres;

--
-- Name: job_role; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.job_role (
    joro_id integer NOT NULL,
    joro_name character varying(55),
    joro_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master.job_role OWNER TO postgres;

--
-- Name: job_role_joro_id_seq; Type: SEQUENCE; Schema: master; Owner: postgres
--

CREATE SEQUENCE master.job_role_joro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master.job_role_joro_id_seq OWNER TO postgres;

--
-- Name: job_role_joro_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: postgres
--

ALTER SEQUENCE master.job_role_joro_id_seq OWNED BY master.job_role.joro_id;


--
-- Name: job_type; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.job_type (
    joty_id integer NOT NULL,
    joty_name character varying(55)
);


ALTER TABLE master.job_type OWNER TO postgres;

--
-- Name: job_type_joty_id_seq; Type: SEQUENCE; Schema: master; Owner: postgres
--

CREATE SEQUENCE master.job_type_joty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master.job_type_joty_id_seq OWNER TO postgres;

--
-- Name: job_type_joty_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: postgres
--

ALTER SEQUENCE master.job_type_joty_id_seq OWNED BY master.job_type.joty_id;


--
-- Name: modules; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.modules (
    module_name character varying(125) NOT NULL
);


ALTER TABLE master.modules OWNER TO postgres;

--
-- Name: province; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.province (
    prov_id integer NOT NULL,
    prov_code character varying(5),
    prov_name character varying(85),
    prov_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    prov_country_code character varying(3)
);


ALTER TABLE master.province OWNER TO postgres;

--
-- Name: province_prov_id_seq; Type: SEQUENCE; Schema: master; Owner: postgres
--

CREATE SEQUENCE master.province_prov_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master.province_prov_id_seq OWNER TO postgres;

--
-- Name: province_prov_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: postgres
--

ALTER SEQUENCE master.province_prov_id_seq OWNED BY master.province.prov_id;


--
-- Name: route_actions; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.route_actions (
    roac_id integer NOT NULL,
    roac_name character varying(15),
    roac_orderby integer,
    roac_display character(1),
    roac_module_name character varying(125),
    CONSTRAINT route_actions_roac_display_check CHECK ((roac_display = ANY (ARRAY['0'::bpchar, '1'::bpchar])))
);


ALTER TABLE master.route_actions OWNER TO postgres;

--
-- Name: route_actions_roac_id_seq; Type: SEQUENCE; Schema: master; Owner: postgres
--

CREATE SEQUENCE master.route_actions_roac_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master.route_actions_roac_id_seq OWNER TO postgres;

--
-- Name: route_actions_roac_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: postgres
--

ALTER SEQUENCE master.route_actions_roac_id_seq OWNED BY master.route_actions.roac_id;


--
-- Name: skill_template; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.skill_template (
    skte_id integer NOT NULL,
    skte_skill character varying(256),
    skte_description character varying(256),
    skte_week integer,
    skte_orderby integer,
    skte_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    skty_name character varying(55),
    skte_skte_id integer
);


ALTER TABLE master.skill_template OWNER TO postgres;

--
-- Name: skill_template_skte_id_seq; Type: SEQUENCE; Schema: master; Owner: postgres
--

CREATE SEQUENCE master.skill_template_skte_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master.skill_template_skte_id_seq OWNER TO postgres;

--
-- Name: skill_template_skte_id_seq; Type: SEQUENCE OWNED BY; Schema: master; Owner: postgres
--

ALTER SEQUENCE master.skill_template_skte_id_seq OWNED BY master.skill_template.skte_id;


--
-- Name: skill_type; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.skill_type (
    skty_name character varying(55) NOT NULL
);


ALTER TABLE master.skill_type OWNER TO postgres;

--
-- Name: status; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.status (
    status character varying(15) NOT NULL,
    status_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master.status OWNER TO postgres;

--
-- Name: working_type; Type: TABLE; Schema: master; Owner: postgres
--

CREATE TABLE master.working_type (
    woty_code character varying(15) NOT NULL,
    woty_name character varying(55)
);


ALTER TABLE master.working_type OWNER TO postgres;

--
-- Name: bank; Type: TABLE; Schema: payment; Owner: postgres
--

CREATE TABLE payment.bank (
    bank_entity_id integer NOT NULL,
    bank_code character varying(10),
    bank_name character varying(55),
    bank_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE payment.bank OWNER TO postgres;

--
-- Name: fintech; Type: TABLE; Schema: payment; Owner: postgres
--

CREATE TABLE payment.fintech (
    fint_entity_id integer NOT NULL,
    fint_code character varying(10),
    fint_name character varying(55),
    fint_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE payment.fintech OWNER TO postgres;

--
-- Name: transaction_payment; Type: TABLE; Schema: payment; Owner: postgres
--

CREATE TABLE payment.transaction_payment (
    trpa_id integer NOT NULL,
    trpa_code_number character varying(55),
    trpa_order_number character varying(25),
    trpa_debet numeric,
    trpa_credit numeric,
    trpa_type character varying(15),
    trpa_note character varying(255),
    trpa_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    trpa_source_id character varying(25) NOT NULL,
    trpa_target_id character varying(25) NOT NULL,
    trpa_user_entity_id integer,
    CONSTRAINT transaction_payment_trpa_type_check CHECK (((trpa_type)::text = ANY ((ARRAY['topup'::character varying, 'transfer'::character varying, 'order'::character varying, 'refund'::character varying])::text[])))
);


ALTER TABLE payment.transaction_payment OWNER TO postgres;

--
-- Name: transaction_payment_trpa_id_seq; Type: SEQUENCE; Schema: payment; Owner: postgres
--

CREATE SEQUENCE payment.transaction_payment_trpa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payment.transaction_payment_trpa_id_seq OWNER TO postgres;

--
-- Name: transaction_payment_trpa_id_seq; Type: SEQUENCE OWNED BY; Schema: payment; Owner: postgres
--

ALTER SEQUENCE payment.transaction_payment_trpa_id_seq OWNED BY payment.transaction_payment.trpa_id;


--
-- Name: users_account; Type: TABLE; Schema: payment; Owner: postgres
--

CREATE TABLE payment.users_account (
    usac_bank_entity_id integer NOT NULL,
    usac_fint_entity_id integer,
    usac_user_entity_id integer NOT NULL,
    usac_account_number character varying(25),
    usac_saldo numeric,
    usac_type character varying(15),
    usac_start_date timestamp with time zone,
    usac_end_date timestamp with time zone,
    usac_modified_date timestamp with time zone DEFAULT now(),
    usac_status character varying(15),
    CONSTRAINT users_account_usac_status_check CHECK (((usac_status)::text = ANY ((ARRAY['active'::character varying, 'nactive'::character varying, 'blokir'::character varying])::text[]))),
    CONSTRAINT users_account_usac_type_check CHECK (((usac_type)::text = ANY ((ARRAY['debet'::character varying, 'credit card'::character varying, 'payment'::character varying])::text[])))
);


ALTER TABLE payment.users_account OWNER TO postgres;

--
-- Name: cart_items; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.cart_items (
    cait_id integer NOT NULL,
    cait_quantity integer,
    cait_unit_price numeric,
    cait_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cait_user_entity_id integer,
    cait_prog_entity_id integer
);


ALTER TABLE sales.cart_items OWNER TO postgres;

--
-- Name: cart_items_cait_id_seq; Type: SEQUENCE; Schema: sales; Owner: postgres
--

CREATE SEQUENCE sales.cart_items_cait_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.cart_items_cait_id_seq OWNER TO postgres;

--
-- Name: cart_items_cait_id_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: postgres
--

ALTER SEQUENCE sales.cart_items_cait_id_seq OWNED BY sales.cart_items.cait_id;


--
-- Name: sales_order_detail; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.sales_order_detail (
    sode_id integer NOT NULL,
    sode_qty integer,
    sode_unit_price numeric,
    sode_unit_discount numeric,
    sode_line_total numeric,
    sode_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    sode_sohe_id integer,
    sode_soco_id integer,
    sode_prog_entity_id integer
);


ALTER TABLE sales.sales_order_detail OWNER TO postgres;

--
-- Name: sales_order_detail_sode_id_seq; Type: SEQUENCE; Schema: sales; Owner: postgres
--

CREATE SEQUENCE sales.sales_order_detail_sode_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.sales_order_detail_sode_id_seq OWNER TO postgres;

--
-- Name: sales_order_detail_sode_id_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: postgres
--

ALTER SEQUENCE sales.sales_order_detail_sode_id_seq OWNED BY sales.sales_order_detail.sode_id;


--
-- Name: sales_order_header; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.sales_order_header (
    sohe_id integer NOT NULL,
    sohe_order_date date,
    sohe_due_date date,
    sohe_ship_date date,
    sohe_order_number character varying(25),
    sohe_account_number character varying(25),
    sohe_trpa_code_number character varying(55),
    sohe_subtotal numeric,
    sohe_tax numeric,
    sohe_total_due numeric,
    sohe_license_code character varying(512),
    sohe_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    sohe_user_entity_id integer,
    sohe_status character varying(15),
    CONSTRAINT sales_order_header_sohe_status_check CHECK (((sohe_status)::text = ANY ((ARRAY['open'::character varying, 'shipping'::character varying, 'cancelled'::character varying, 'refund'::character varying])::text[])))
);


ALTER TABLE sales.sales_order_header OWNER TO postgres;

--
-- Name: sales_order_header_sohe_id_seq; Type: SEQUENCE; Schema: sales; Owner: postgres
--

CREATE SEQUENCE sales.sales_order_header_sohe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.sales_order_header_sohe_id_seq OWNER TO postgres;

--
-- Name: sales_order_header_sohe_id_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: postgres
--

ALTER SEQUENCE sales.sales_order_header_sohe_id_seq OWNED BY sales.sales_order_header.sohe_id;


--
-- Name: special_offer; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.special_offer (
    spof_id integer NOT NULL,
    spof_description character varying(256),
    spof_discount numeric,
    spof_type character varying(15),
    spof_start_date date,
    spof_end_date date,
    spof_min_qty integer,
    spof_max_qty integer,
    spof_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    spof_cate_id integer
);


ALTER TABLE sales.special_offer OWNER TO postgres;

--
-- Name: special_offer_programs; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.special_offer_programs (
    soco_id integer NOT NULL,
    soco_spof_id integer NOT NULL,
    soco_prog_entity_id integer NOT NULL,
    soco_status character varying(15),
    soco_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT special_offer_programs_soco_status_check CHECK (((soco_status)::text = ANY ((ARRAY['open'::character varying, 'cancelled'::character varying, 'closed'::character varying])::text[])))
);


ALTER TABLE sales.special_offer_programs OWNER TO postgres;

--
-- Name: special_offer_programs_soco_id_seq; Type: SEQUENCE; Schema: sales; Owner: postgres
--

CREATE SEQUENCE sales.special_offer_programs_soco_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.special_offer_programs_soco_id_seq OWNER TO postgres;

--
-- Name: special_offer_programs_soco_id_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: postgres
--

ALTER SEQUENCE sales.special_offer_programs_soco_id_seq OWNED BY sales.special_offer_programs.soco_id;


--
-- Name: special_offer_spof_id_seq; Type: SEQUENCE; Schema: sales; Owner: postgres
--

CREATE SEQUENCE sales.special_offer_spof_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.special_offer_spof_id_seq OWNER TO postgres;

--
-- Name: special_offer_spof_id_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: postgres
--

ALTER SEQUENCE sales.special_offer_spof_id_seq OWNED BY sales.special_offer.spof_id;


--
-- Name: business_entity; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.business_entity (
    entity_id integer NOT NULL
);


ALTER TABLE users.business_entity OWNER TO postgres;

--
-- Name: business_entity_entity_id_seq; Type: SEQUENCE; Schema: users; Owner: postgres
--

CREATE SEQUENCE users.business_entity_entity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users.business_entity_entity_id_seq OWNER TO postgres;

--
-- Name: business_entity_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: postgres
--

ALTER SEQUENCE users.business_entity_entity_id_seq OWNED BY users.business_entity.entity_id;


--
-- Name: phone_number_type; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.phone_number_type (
    ponty_code character varying(15) NOT NULL,
    ponty_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE users.phone_number_type OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.roles (
    role_id integer NOT NULL,
    role_name character varying(35),
    role_type character varying(15),
    role_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE users.roles OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: users; Owner: postgres
--

CREATE SEQUENCE users.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users.roles_role_id_seq OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: postgres
--

ALTER SEQUENCE users.roles_role_id_seq OWNED BY users.roles.role_id;


--
-- Name: users; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.users (
    user_entity_id integer NOT NULL,
    user_name character varying(15),
    user_password character varying(256),
    user_first_name character varying(50),
    user_last_name character varying(50),
    user_birth_date date,
    user_email_promotion integer DEFAULT 0,
    user_demographic json,
    user_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_photo character varying(255),
    user_current_role integer
);


ALTER TABLE users.users OWNER TO postgres;

--
-- Name: users_address; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.users_address (
    etad_addr_id integer NOT NULL,
    etad_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    etad_entity_id integer,
    etad_adty_id integer
);


ALTER TABLE users.users_address OWNER TO postgres;

--
-- Name: users_education; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.users_education (
    usdu_id integer NOT NULL,
    usdu_entity_id integer NOT NULL,
    usdu_school character varying(255),
    usdu_degree character varying(15),
    usdu_field_study character varying(125),
    usdu_graduate_year character varying(4),
    usdu_start_date date,
    usdu_end_date date,
    usdu_grade character varying(5),
    usdu_activities character varying(512),
    usdu_description character varying(512),
    usdu_modified_data timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT users_education_usdu_degree_check CHECK (((usdu_degree)::text = ANY ((ARRAY['Bachelor'::character varying, 'Diploma'::character varying])::text[])))
);


ALTER TABLE users.users_education OWNER TO postgres;

--
-- Name: users_education_usdu_id_seq; Type: SEQUENCE; Schema: users; Owner: postgres
--

CREATE SEQUENCE users.users_education_usdu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users.users_education_usdu_id_seq OWNER TO postgres;

--
-- Name: users_education_usdu_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: postgres
--

ALTER SEQUENCE users.users_education_usdu_id_seq OWNED BY users.users_education.usdu_id;


--
-- Name: users_email; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.users_email (
    pmail_entity_id integer NOT NULL,
    pmail_id integer NOT NULL,
    pmail_address character varying(50),
    pmail_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE users.users_email OWNER TO postgres;

--
-- Name: users_email_pmail_id_seq; Type: SEQUENCE; Schema: users; Owner: postgres
--

CREATE SEQUENCE users.users_email_pmail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users.users_email_pmail_id_seq OWNER TO postgres;

--
-- Name: users_email_pmail_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: postgres
--

ALTER SEQUENCE users.users_email_pmail_id_seq OWNED BY users.users_email.pmail_id;


--
-- Name: users_experiences; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.users_experiences (
    usex_id integer NOT NULL,
    usex_entity_id integer NOT NULL,
    usex_title character varying(255),
    usex_profile_headline character varying(512),
    usex_employment_type character varying(15),
    usex_company_name character varying(255),
    usex_is_current character(1),
    usex_start_date date,
    usex_end_date date,
    usex_industry character varying(15),
    usex_description character varying(512),
    usex_experience_type character varying(15),
    usex_city_id integer,
    CONSTRAINT users_experiences_usex_employment_type_check CHECK (((usex_employment_type)::text = ANY ((ARRAY['fulltime'::character varying, 'freelance'::character varying])::text[]))),
    CONSTRAINT users_experiences_usex_experience_type_check CHECK (((usex_experience_type)::text = ANY ((ARRAY['company'::character varying, 'certified'::character varying, 'voluntering'::character varying, 'organization'::character varying, 'reward'::character varying])::text[]))),
    CONSTRAINT users_experiences_usex_is_current_check CHECK ((usex_is_current = ANY (ARRAY['0'::bpchar, '1'::bpchar])))
);


ALTER TABLE users.users_experiences OWNER TO postgres;

--
-- Name: users_experiences_skill; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.users_experiences_skill (
    uesk_usex_id integer NOT NULL,
    uesk_uski_id integer NOT NULL
);


ALTER TABLE users.users_experiences_skill OWNER TO postgres;

--
-- Name: users_experiences_usex_id_seq; Type: SEQUENCE; Schema: users; Owner: postgres
--

CREATE SEQUENCE users.users_experiences_usex_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users.users_experiences_usex_id_seq OWNER TO postgres;

--
-- Name: users_experiences_usex_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: postgres
--

ALTER SEQUENCE users.users_experiences_usex_id_seq OWNED BY users.users_experiences.usex_id;


--
-- Name: users_license; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.users_license (
    usli_id integer NOT NULL,
    usli_license_code character varying(512),
    usli_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usli_status character varying(15),
    usli_entity_id integer NOT NULL,
    CONSTRAINT users_license_usli_status_check CHECK (((usli_status)::text = ANY ((ARRAY['Active'::character varying, 'NonActive'::character varying])::text[])))
);


ALTER TABLE users.users_license OWNER TO postgres;

--
-- Name: users_license_usli_id_seq; Type: SEQUENCE; Schema: users; Owner: postgres
--

CREATE SEQUENCE users.users_license_usli_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users.users_license_usli_id_seq OWNER TO postgres;

--
-- Name: users_license_usli_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: postgres
--

ALTER SEQUENCE users.users_license_usli_id_seq OWNED BY users.users_license.usli_id;


--
-- Name: users_media; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.users_media (
    usme_id integer NOT NULL,
    usme_entity_id integer NOT NULL,
    usme_filelink character varying(255),
    usme_filename character varying(55),
    usme_filetype character varying(15),
    usme_note character varying(55),
    usme_modified_data timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT users_media_usme_filetype_check CHECK (((usme_filetype)::text = ANY ((ARRAY['jpg'::character varying, 'pdf'::character varying, 'word'::character varying])::text[])))
);


ALTER TABLE users.users_media OWNER TO postgres;

--
-- Name: users_media_usme_id_seq; Type: SEQUENCE; Schema: users; Owner: postgres
--

CREATE SEQUENCE users.users_media_usme_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users.users_media_usme_id_seq OWNER TO postgres;

--
-- Name: users_media_usme_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: postgres
--

ALTER SEQUENCE users.users_media_usme_id_seq OWNED BY users.users_media.usme_id;


--
-- Name: users_phones; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.users_phones (
    uspo_entity_id integer NOT NULL,
    uspo_number character varying(15) NOT NULL,
    uspo_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    uspo_ponty_code character varying(15)
);


ALTER TABLE users.users_phones OWNER TO postgres;

--
-- Name: users_roles; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.users_roles (
    usro_entity_id integer NOT NULL,
    usro_role_id integer NOT NULL,
    usro_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE users.users_roles OWNER TO postgres;

--
-- Name: users_skill; Type: TABLE; Schema: users; Owner: postgres
--

CREATE TABLE users.users_skill (
    uski_id integer NOT NULL,
    uski_entity_id integer NOT NULL,
    uski_modified_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    uski_skty_name character varying(15)
);


ALTER TABLE users.users_skill OWNER TO postgres;

--
-- Name: users_skill_uski_id_seq; Type: SEQUENCE; Schema: users; Owner: postgres
--

CREATE SEQUENCE users.users_skill_uski_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users.users_skill_uski_id_seq OWNER TO postgres;

--
-- Name: users_skill_uski_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: postgres
--

ALTER SEQUENCE users.users_skill_uski_id_seq OWNED BY users.users_skill.uski_id;


--
-- Name: batch batch_id; Type: DEFAULT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch ALTER COLUMN batch_id SET DEFAULT nextval('bootcamp.batch_batch_id_seq'::regclass);


--
-- Name: batch_trainee batr_id; Type: DEFAULT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch_trainee ALTER COLUMN batr_id SET DEFAULT nextval('bootcamp.batch_trainee_batr_id_seq'::regclass);


--
-- Name: batch_trainee_evaluation btev_id; Type: DEFAULT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch_trainee_evaluation ALTER COLUMN btev_id SET DEFAULT nextval('bootcamp.batch_trainee_evaluation_btev_id_seq'::regclass);


--
-- Name: program_apply_progress parog_id; Type: DEFAULT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.program_apply_progress ALTER COLUMN parog_id SET DEFAULT nextval('bootcamp.program_apply_progress_parog_id_seq'::regclass);


--
-- Name: talents talent_id; Type: DEFAULT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.talents ALTER COLUMN talent_id SET DEFAULT nextval('bootcamp.talents_talent_id_seq'::regclass);


--
-- Name: program_entity prog_entity_id; Type: DEFAULT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.program_entity ALTER COLUMN prog_entity_id SET DEFAULT nextval('curriculum.program_entity_prog_entity_id_seq'::regclass);


--
-- Name: section_detail secd_id; Type: DEFAULT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.section_detail ALTER COLUMN secd_id SET DEFAULT nextval('curriculum.section_detail_secd_id_seq'::regclass);


--
-- Name: section_detail_material sedm_id; Type: DEFAULT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.section_detail_material ALTER COLUMN sedm_id SET DEFAULT nextval('curriculum.section_detail_material_sedm_id_seq'::regclass);


--
-- Name: section_detail_material sedm_secd_id; Type: DEFAULT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.section_detail_material ALTER COLUMN sedm_secd_id SET DEFAULT nextval('curriculum.section_detail_material_sedm_secd_id_seq'::regclass);


--
-- Name: sections sect_id; Type: DEFAULT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.sections ALTER COLUMN sect_id SET DEFAULT nextval('curriculum.sections_sect_id_seq'::regclass);


--
-- Name: department dept_id; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.department ALTER COLUMN dept_id SET DEFAULT nextval('hr.department_dept_id_seq'::regclass);


--
-- Name: employee_department_history edhi_id; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee_department_history ALTER COLUMN edhi_id SET DEFAULT nextval('hr.employee_department_history_edhi_id_seq'::regclass);


--
-- Name: client clit_id; Type: DEFAULT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.client ALTER COLUMN clit_id SET DEFAULT nextval('job_hire.client_clit_id_seq'::regclass);


--
-- Name: employee_range emra_id; Type: DEFAULT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.employee_range ALTER COLUMN emra_id SET DEFAULT nextval('job_hire.employee_range_emra_id_seq'::regclass);


--
-- Name: job_category joca_id; Type: DEFAULT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_category ALTER COLUMN joca_id SET DEFAULT nextval('job_hire.job_category_joca_id_seq'::regclass);


--
-- Name: job_photo jopho_id; Type: DEFAULT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_photo ALTER COLUMN jopho_id SET DEFAULT nextval('job_hire.job_photo_jopho_id_seq'::regclass);


--
-- Name: job_post jopo_entity_id; Type: DEFAULT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post ALTER COLUMN jopo_entity_id SET DEFAULT nextval('job_hire.job_post_jopo_entity_id_seq'::regclass);


--
-- Name: talent_apply_progress tapr_id; Type: DEFAULT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.talent_apply_progress ALTER COLUMN tapr_id SET DEFAULT nextval('job_hire.talent_apply_progress_tapr_id_seq'::regclass);


--
-- Name: address addr_id; Type: DEFAULT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.address ALTER COLUMN addr_id SET DEFAULT nextval('master.address_addr_id_seq'::regclass);


--
-- Name: address_type adty_id; Type: DEFAULT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.address_type ALTER COLUMN adty_id SET DEFAULT nextval('master.address_type_adty_id_seq'::regclass);


--
-- Name: category cate_id; Type: DEFAULT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.category ALTER COLUMN cate_id SET DEFAULT nextval('master.category_cate_id_seq'::regclass);


--
-- Name: city city_id; Type: DEFAULT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.city ALTER COLUMN city_id SET DEFAULT nextval('master.city_city_id_seq'::regclass);


--
-- Name: job_role joro_id; Type: DEFAULT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.job_role ALTER COLUMN joro_id SET DEFAULT nextval('master.job_role_joro_id_seq'::regclass);


--
-- Name: job_type joty_id; Type: DEFAULT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.job_type ALTER COLUMN joty_id SET DEFAULT nextval('master.job_type_joty_id_seq'::regclass);


--
-- Name: province prov_id; Type: DEFAULT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.province ALTER COLUMN prov_id SET DEFAULT nextval('master.province_prov_id_seq'::regclass);


--
-- Name: route_actions roac_id; Type: DEFAULT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.route_actions ALTER COLUMN roac_id SET DEFAULT nextval('master.route_actions_roac_id_seq'::regclass);


--
-- Name: skill_template skte_id; Type: DEFAULT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.skill_template ALTER COLUMN skte_id SET DEFAULT nextval('master.skill_template_skte_id_seq'::regclass);


--
-- Name: transaction_payment trpa_id; Type: DEFAULT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.transaction_payment ALTER COLUMN trpa_id SET DEFAULT nextval('payment.transaction_payment_trpa_id_seq'::regclass);


--
-- Name: cart_items cait_id; Type: DEFAULT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.cart_items ALTER COLUMN cait_id SET DEFAULT nextval('sales.cart_items_cait_id_seq'::regclass);


--
-- Name: sales_order_detail sode_id; Type: DEFAULT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.sales_order_detail ALTER COLUMN sode_id SET DEFAULT nextval('sales.sales_order_detail_sode_id_seq'::regclass);


--
-- Name: sales_order_header sohe_id; Type: DEFAULT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.sales_order_header ALTER COLUMN sohe_id SET DEFAULT nextval('sales.sales_order_header_sohe_id_seq'::regclass);


--
-- Name: special_offer spof_id; Type: DEFAULT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.special_offer ALTER COLUMN spof_id SET DEFAULT nextval('sales.special_offer_spof_id_seq'::regclass);


--
-- Name: special_offer_programs soco_id; Type: DEFAULT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.special_offer_programs ALTER COLUMN soco_id SET DEFAULT nextval('sales.special_offer_programs_soco_id_seq'::regclass);


--
-- Name: business_entity entity_id; Type: DEFAULT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.business_entity ALTER COLUMN entity_id SET DEFAULT nextval('users.business_entity_entity_id_seq'::regclass);


--
-- Name: roles role_id; Type: DEFAULT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.roles ALTER COLUMN role_id SET DEFAULT nextval('users.roles_role_id_seq'::regclass);


--
-- Name: users_education usdu_id; Type: DEFAULT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_education ALTER COLUMN usdu_id SET DEFAULT nextval('users.users_education_usdu_id_seq'::regclass);


--
-- Name: users_email pmail_id; Type: DEFAULT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_email ALTER COLUMN pmail_id SET DEFAULT nextval('users.users_email_pmail_id_seq'::regclass);


--
-- Name: users_experiences usex_id; Type: DEFAULT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_experiences ALTER COLUMN usex_id SET DEFAULT nextval('users.users_experiences_usex_id_seq'::regclass);


--
-- Name: users_license usli_id; Type: DEFAULT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_license ALTER COLUMN usli_id SET DEFAULT nextval('users.users_license_usli_id_seq'::regclass);


--
-- Name: users_media usme_id; Type: DEFAULT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_media ALTER COLUMN usme_id SET DEFAULT nextval('users.users_media_usme_id_seq'::regclass);


--
-- Name: users_skill uski_id; Type: DEFAULT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_skill ALTER COLUMN uski_id SET DEFAULT nextval('users.users_skill_uski_id_seq'::regclass);


--
-- Data for Name: batch; Type: TABLE DATA; Schema: bootcamp; Owner: postgres
--

COPY bootcamp.batch (batch_id, batch_entity_id, batch_name, batch_description, batch_start_date, batch_end_date, batch_reason, batch_type, batch_modified_date, batch_status, batch_pic_id) FROM stdin;
\.


--
-- Data for Name: batch_trainee; Type: TABLE DATA; Schema: bootcamp; Owner: postgres
--

COPY bootcamp.batch_trainee (batr_id, batr_status, batr_certificated, batr_certificate_link, batr_access_token, batr_access_grant, batr_review, batr_total_score, batr_modified_date, batr_trainee_entity_id, batr_batch_id) FROM stdin;
\.


--
-- Data for Name: batch_trainee_evaluation; Type: TABLE DATA; Schema: bootcamp; Owner: postgres
--

COPY bootcamp.batch_trainee_evaluation (btev_id, btev_type, btev_header, btev_section, btev_skill, btev_week, btev_skor, btev_note, btev_modified_date, btev_batch_id, btev_trainee_entity_id) FROM stdin;
\.


--
-- Data for Name: instructor_programs; Type: TABLE DATA; Schema: bootcamp; Owner: postgres
--

COPY bootcamp.instructor_programs (inpro_batch_id, inpro_entity_id, inpro_emp_entity_id, inpro_modified_date) FROM stdin;
\.


--
-- Data for Name: program_apply; Type: TABLE DATA; Schema: bootcamp; Owner: postgres
--

COPY bootcamp.program_apply (prap_user_entity_id, prap_prog_entity_id, prap_test_score, prap_gpa, prap_iq_test, prap_review, prap_modified_date, prap_status) FROM stdin;
\.


--
-- Data for Name: program_apply_progress; Type: TABLE DATA; Schema: bootcamp; Owner: postgres
--

COPY bootcamp.program_apply_progress (parog_id, parog_user_entity_id, parog_prog_entity_id, parog_action_date, parog_modified_date, parog_comment, parog_progress_name, parog_emp_entity_id, parog_status) FROM stdin;
\.


--
-- Data for Name: talents; Type: TABLE DATA; Schema: bootcamp; Owner: postgres
--

COPY bootcamp.talents (talent_id, talent_fullname, talent_user_entity_id, talent_technology, talent_batch_id, talent_status, talent_skill) FROM stdin;
\.


--
-- Data for Name: program_entity; Type: TABLE DATA; Schema: curriculum; Owner: postgres
--

COPY curriculum.program_entity (prog_entity_id, prog_title, prog_headline, prog_type, prog_learning_type, prog_rating, prog_total_trainee, prog_image, prog_best_seller, prog_price, prog_language, prog_modified_date, prog_duration, prog_duration_type, prog_tag_skill, prog_city_id, prog_cate_id, prog_created_by, prog_status) FROM stdin;
\.


--
-- Data for Name: program_entity_description; Type: TABLE DATA; Schema: curriculum; Owner: postgres
--

COPY curriculum.program_entity_description (pred_prog_entity_id, pred_item_learning, pred_item_include, pred_requirement, pred_description, pred_target_level) FROM stdin;
\.


--
-- Data for Name: program_reviews; Type: TABLE DATA; Schema: curriculum; Owner: postgres
--

COPY curriculum.program_reviews (prow_user_entity_id, prow_prog_entity_id, prow_review, prow_rating, prow_modified_date) FROM stdin;
\.


--
-- Data for Name: section_detail; Type: TABLE DATA; Schema: curriculum; Owner: postgres
--

COPY curriculum.section_detail (secd_id, secd_title, secd_preview, secd_score, secd_note, secd_minute, secd_modified_date, secd_sect_id) FROM stdin;
\.


--
-- Data for Name: section_detail_material; Type: TABLE DATA; Schema: curriculum; Owner: postgres
--

COPY curriculum.section_detail_material (sedm_id, sedm_filename, sedm_filesize, sedm_filetype, sedm_filelink, sedm_modified_date, sedm_secd_id) FROM stdin;
\.


--
-- Data for Name: sections; Type: TABLE DATA; Schema: curriculum; Owner: postgres
--

COPY curriculum.sections (sect_id, sect_prog_entity_id, sect_title, sect_description, sect_total_section, sect_total_lecture, sect_total_minute, sect_modified_date) FROM stdin;
\.


--
-- Data for Name: department; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.department (dept_id, dept_name, dept_modified_date) FROM stdin;
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.employee (emp_entity_id, emp_emp_number, emp_national_id, emp_birth_date, emp_marital_status, emp_gender, emp_hire_date, emp_salaried_flag, emp_vacation_hours, emp_sickleave_hours, emp_current_flag, emp_modified_date, emp_type, emp_joro_id, emp_emp_entity_id) FROM stdin;
\.


--
-- Data for Name: employee_department_history; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.employee_department_history (edhi_id, edhi_entity_id, edhi_start_date, edhi_end_date, edhi_modified_date, edhi_dept_id) FROM stdin;
\.


--
-- Data for Name: employee_pay_history; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.employee_pay_history (ephi_entity_id, ephi_rate_change_date, ephi_rate_salary, ephi_pay_frequence, ephi_modified_date) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: job_hire; Owner: postgres
--

COPY job_hire.client (clit_id, clit_name, clit_about, clit_modified_date, clit_addr_id, clit_emra_id) FROM stdin;
\.


--
-- Data for Name: employee_range; Type: TABLE DATA; Schema: job_hire; Owner: postgres
--

COPY job_hire.employee_range (emra_id, emra_range_min, emra_range_max, emra_modified_date) FROM stdin;
\.


--
-- Data for Name: job_category; Type: TABLE DATA; Schema: job_hire; Owner: postgres
--

COPY job_hire.job_category (joca_id, joca_name, joca_modified_date) FROM stdin;
\.


--
-- Data for Name: job_photo; Type: TABLE DATA; Schema: job_hire; Owner: postgres
--

COPY job_hire.job_photo (jopho_id, jopho_filename, jopho_filesize, jopho_filetype, jopho_modified_date, jopho_entity_id) FROM stdin;
\.


--
-- Data for Name: job_post; Type: TABLE DATA; Schema: job_hire; Owner: postgres
--

COPY job_hire.job_post (jopo_entity_id, jopo_number, jopo_title, jopo_start_date, jopo_end_date, jopo_min_salary, jopo_max_salary, jopo_min_experience, jopo_max_experience, jopo_primary_skill, jopo_secondary_skill, jopo_publish_date, jopo_modified_date, jopo_emp_entity_id, jopo_clit_id, jopo_joro_id, jopo_joty_id, jopo_joca_id, jopo_addr_id, jopo_work_code, jopo_edu_code, jopo_indu_code, jopo_status) FROM stdin;
\.


--
-- Data for Name: job_post_desc; Type: TABLE DATA; Schema: job_hire; Owner: postgres
--

COPY job_hire.job_post_desc (jopo_entity_id, jopo_description, jopo_responsibility, jopo_target, jopo_benefit) FROM stdin;
\.


--
-- Data for Name: talent_apply; Type: TABLE DATA; Schema: job_hire; Owner: postgres
--

COPY job_hire.talent_apply (taap_user_entity_id, taap_entity_id, taap_intro, taap_scoring, taap_modified_date, taap_status) FROM stdin;
\.


--
-- Data for Name: talent_apply_progress; Type: TABLE DATA; Schema: job_hire; Owner: postgres
--

COPY job_hire.talent_apply_progress (tapr_id, tapr_taap_user_entity_id, tapr_taap_entity_id, tapr_modified_date, tapr_status, tapr_comment, tapr_progress_name) FROM stdin;
\.


--
-- Data for Name: address; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.address (addr_id, addr_line1, addr_line2, addr_postal_code, addr_spatial_location, addr_modifed_date, addr_city_id) FROM stdin;
1	jalan garuda1212	jalan rajawali1212	88880	"antara jalan garuda dan rajawali"	2023-05-27 20:56:26.835595+07	1
\.


--
-- Data for Name: address_type; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.address_type (adty_id, adty_name, adty_modified_date) FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.category (cate_id, cate_name, cate_cate_id, cate_modified_date) FROM stdin;
\.


--
-- Data for Name: city; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.city (city_id, city_name, city_modified_date, city_prov_id) FROM stdin;
1	bogor	2023-05-28 13:20:47.679272+07	1
\.


--
-- Data for Name: country; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.country (country_code, country_name, country_modified_date) FROM stdin;
IDN	indonesia	2023-05-28 13:05:16.257821+07
MLY	malaysia	2023-05-28 15:47:21.74727+07
\.


--
-- Data for Name: education; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.education (edu_code, edu_name) FROM stdin;
\.


--
-- Data for Name: industry; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.industry (indu_code, indu_name) FROM stdin;
\.


--
-- Data for Name: job_role; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.job_role (joro_id, joro_name, joro_modified_date) FROM stdin;
\.


--
-- Data for Name: job_type; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.job_type (joty_id, joty_name) FROM stdin;
\.


--
-- Data for Name: modules; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.modules (module_name) FROM stdin;
coba
\.


--
-- Data for Name: province; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.province (prov_id, prov_code, prov_name, prov_modified_date, prov_country_code) FROM stdin;
1	JABAR	jawa barat	2023-05-28 13:12:04.626687+07	IDN
\.


--
-- Data for Name: route_actions; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.route_actions (roac_id, roac_name, roac_orderby, roac_display, roac_module_name) FROM stdin;
1	apply	\N	\N	\N
\.


--
-- Data for Name: skill_template; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.skill_template (skte_id, skte_skill, skte_description, skte_week, skte_orderby, skte_modified_date, skty_name, skte_skte_id) FROM stdin;
\.


--
-- Data for Name: skill_type; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.skill_type (skty_name) FROM stdin;
java
javascript
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.status (status, status_modified_date) FROM stdin;
passed	2023-06-08 10:38:45.734767+07
\.


--
-- Data for Name: working_type; Type: TABLE DATA; Schema: master; Owner: postgres
--

COPY master.working_type (woty_code, woty_name) FROM stdin;
\.


--
-- Data for Name: bank; Type: TABLE DATA; Schema: payment; Owner: postgres
--

COPY payment.bank (bank_entity_id, bank_code, bank_name, bank_modified_date) FROM stdin;
\.


--
-- Data for Name: fintech; Type: TABLE DATA; Schema: payment; Owner: postgres
--

COPY payment.fintech (fint_entity_id, fint_code, fint_name, fint_modified_date) FROM stdin;
\.


--
-- Data for Name: transaction_payment; Type: TABLE DATA; Schema: payment; Owner: postgres
--

COPY payment.transaction_payment (trpa_id, trpa_code_number, trpa_order_number, trpa_debet, trpa_credit, trpa_type, trpa_note, trpa_modified_date, trpa_source_id, trpa_target_id, trpa_user_entity_id) FROM stdin;
\.


--
-- Data for Name: users_account; Type: TABLE DATA; Schema: payment; Owner: postgres
--

COPY payment.users_account (usac_bank_entity_id, usac_fint_entity_id, usac_user_entity_id, usac_account_number, usac_saldo, usac_type, usac_start_date, usac_end_date, usac_modified_date, usac_status) FROM stdin;
\.


--
-- Data for Name: cart_items; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.cart_items (cait_id, cait_quantity, cait_unit_price, cait_modified_date, cait_user_entity_id, cait_prog_entity_id) FROM stdin;
\.


--
-- Data for Name: sales_order_detail; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.sales_order_detail (sode_id, sode_qty, sode_unit_price, sode_unit_discount, sode_line_total, sode_modified_date, sode_sohe_id, sode_soco_id, sode_prog_entity_id) FROM stdin;
\.


--
-- Data for Name: sales_order_header; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.sales_order_header (sohe_id, sohe_order_date, sohe_due_date, sohe_ship_date, sohe_order_number, sohe_account_number, sohe_trpa_code_number, sohe_subtotal, sohe_tax, sohe_total_due, sohe_license_code, sohe_modified_date, sohe_user_entity_id, sohe_status) FROM stdin;
\.


--
-- Data for Name: special_offer; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.special_offer (spof_id, spof_description, spof_discount, spof_type, spof_start_date, spof_end_date, spof_min_qty, spof_max_qty, spof_modified_date, spof_cate_id) FROM stdin;
\.


--
-- Data for Name: special_offer_programs; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.special_offer_programs (soco_id, soco_spof_id, soco_prog_entity_id, soco_status, soco_modified_date) FROM stdin;
\.


--
-- Data for Name: business_entity; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.business_entity (entity_id) FROM stdin;
\.


--
-- Data for Name: phone_number_type; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.phone_number_type (ponty_code, ponty_modified_date) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.roles (role_id, role_name, role_type, role_modified_date) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.users (user_entity_id, user_name, user_password, user_first_name, user_last_name, user_birth_date, user_email_promotion, user_demographic, user_modified_date, user_photo, user_current_role) FROM stdin;
\.


--
-- Data for Name: users_address; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.users_address (etad_addr_id, etad_modified_date, etad_entity_id, etad_adty_id) FROM stdin;
\.


--
-- Data for Name: users_education; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.users_education (usdu_id, usdu_entity_id, usdu_school, usdu_degree, usdu_field_study, usdu_graduate_year, usdu_start_date, usdu_end_date, usdu_grade, usdu_activities, usdu_description, usdu_modified_data) FROM stdin;
\.


--
-- Data for Name: users_email; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.users_email (pmail_entity_id, pmail_id, pmail_address, pmail_modified_date) FROM stdin;
\.


--
-- Data for Name: users_experiences; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.users_experiences (usex_id, usex_entity_id, usex_title, usex_profile_headline, usex_employment_type, usex_company_name, usex_is_current, usex_start_date, usex_end_date, usex_industry, usex_description, usex_experience_type, usex_city_id) FROM stdin;
\.


--
-- Data for Name: users_experiences_skill; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.users_experiences_skill (uesk_usex_id, uesk_uski_id) FROM stdin;
\.


--
-- Data for Name: users_license; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.users_license (usli_id, usli_license_code, usli_modified_date, usli_status, usli_entity_id) FROM stdin;
\.


--
-- Data for Name: users_media; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.users_media (usme_id, usme_entity_id, usme_filelink, usme_filename, usme_filetype, usme_note, usme_modified_data) FROM stdin;
\.


--
-- Data for Name: users_phones; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.users_phones (uspo_entity_id, uspo_number, uspo_modified_date, uspo_ponty_code) FROM stdin;
\.


--
-- Data for Name: users_roles; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.users_roles (usro_entity_id, usro_role_id, usro_modified_date) FROM stdin;
\.


--
-- Data for Name: users_skill; Type: TABLE DATA; Schema: users; Owner: postgres
--

COPY users.users_skill (uski_id, uski_entity_id, uski_modified_date, uski_skty_name) FROM stdin;
\.


--
-- Name: batch_batch_id_seq; Type: SEQUENCE SET; Schema: bootcamp; Owner: postgres
--

SELECT pg_catalog.setval('bootcamp.batch_batch_id_seq', 1, false);


--
-- Name: batch_trainee_batr_id_seq; Type: SEQUENCE SET; Schema: bootcamp; Owner: postgres
--

SELECT pg_catalog.setval('bootcamp.batch_trainee_batr_id_seq', 1, false);


--
-- Name: batch_trainee_evaluation_btev_id_seq; Type: SEQUENCE SET; Schema: bootcamp; Owner: postgres
--

SELECT pg_catalog.setval('bootcamp.batch_trainee_evaluation_btev_id_seq', 1, false);


--
-- Name: program_apply_progress_parog_id_seq; Type: SEQUENCE SET; Schema: bootcamp; Owner: postgres
--

SELECT pg_catalog.setval('bootcamp.program_apply_progress_parog_id_seq', 1, false);


--
-- Name: talents_talent_id_seq; Type: SEQUENCE SET; Schema: bootcamp; Owner: postgres
--

SELECT pg_catalog.setval('bootcamp.talents_talent_id_seq', 1, false);


--
-- Name: program_entity_prog_entity_id_seq; Type: SEQUENCE SET; Schema: curriculum; Owner: postgres
--

SELECT pg_catalog.setval('curriculum.program_entity_prog_entity_id_seq', 1, false);


--
-- Name: section_detail_material_sedm_id_seq; Type: SEQUENCE SET; Schema: curriculum; Owner: postgres
--

SELECT pg_catalog.setval('curriculum.section_detail_material_sedm_id_seq', 1, false);


--
-- Name: section_detail_material_sedm_secd_id_seq; Type: SEQUENCE SET; Schema: curriculum; Owner: postgres
--

SELECT pg_catalog.setval('curriculum.section_detail_material_sedm_secd_id_seq', 1, false);


--
-- Name: section_detail_secd_id_seq; Type: SEQUENCE SET; Schema: curriculum; Owner: postgres
--

SELECT pg_catalog.setval('curriculum.section_detail_secd_id_seq', 1, false);


--
-- Name: sections_sect_id_seq; Type: SEQUENCE SET; Schema: curriculum; Owner: postgres
--

SELECT pg_catalog.setval('curriculum.sections_sect_id_seq', 1, false);


--
-- Name: department_dept_id_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.department_dept_id_seq', 1, false);


--
-- Name: employee_department_history_edhi_id_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.employee_department_history_edhi_id_seq', 1, false);


--
-- Name: client_clit_id_seq; Type: SEQUENCE SET; Schema: job_hire; Owner: postgres
--

SELECT pg_catalog.setval('job_hire.client_clit_id_seq', 1, false);


--
-- Name: employee_range_emra_id_seq; Type: SEQUENCE SET; Schema: job_hire; Owner: postgres
--

SELECT pg_catalog.setval('job_hire.employee_range_emra_id_seq', 1, false);


--
-- Name: job_category_joca_id_seq; Type: SEQUENCE SET; Schema: job_hire; Owner: postgres
--

SELECT pg_catalog.setval('job_hire.job_category_joca_id_seq', 1, false);


--
-- Name: job_photo_jopho_id_seq; Type: SEQUENCE SET; Schema: job_hire; Owner: postgres
--

SELECT pg_catalog.setval('job_hire.job_photo_jopho_id_seq', 1, false);


--
-- Name: job_post_jopo_entity_id_seq; Type: SEQUENCE SET; Schema: job_hire; Owner: postgres
--

SELECT pg_catalog.setval('job_hire.job_post_jopo_entity_id_seq', 1, false);


--
-- Name: talent_apply_progress_tapr_id_seq; Type: SEQUENCE SET; Schema: job_hire; Owner: postgres
--

SELECT pg_catalog.setval('job_hire.talent_apply_progress_tapr_id_seq', 1, false);


--
-- Name: address_addr_id_seq; Type: SEQUENCE SET; Schema: master; Owner: postgres
--

SELECT pg_catalog.setval('master.address_addr_id_seq', 1, true);


--
-- Name: address_type_adty_id_seq; Type: SEQUENCE SET; Schema: master; Owner: postgres
--

SELECT pg_catalog.setval('master.address_type_adty_id_seq', 1, false);


--
-- Name: category_cate_id_seq; Type: SEQUENCE SET; Schema: master; Owner: postgres
--

SELECT pg_catalog.setval('master.category_cate_id_seq', 1, false);


--
-- Name: city_city_id_seq; Type: SEQUENCE SET; Schema: master; Owner: postgres
--

SELECT pg_catalog.setval('master.city_city_id_seq', 1, true);


--
-- Name: job_role_joro_id_seq; Type: SEQUENCE SET; Schema: master; Owner: postgres
--

SELECT pg_catalog.setval('master.job_role_joro_id_seq', 1, false);


--
-- Name: job_type_joty_id_seq; Type: SEQUENCE SET; Schema: master; Owner: postgres
--

SELECT pg_catalog.setval('master.job_type_joty_id_seq', 1, false);


--
-- Name: province_prov_id_seq; Type: SEQUENCE SET; Schema: master; Owner: postgres
--

SELECT pg_catalog.setval('master.province_prov_id_seq', 1, true);


--
-- Name: route_actions_roac_id_seq; Type: SEQUENCE SET; Schema: master; Owner: postgres
--

SELECT pg_catalog.setval('master.route_actions_roac_id_seq', 1, true);


--
-- Name: skill_template_skte_id_seq; Type: SEQUENCE SET; Schema: master; Owner: postgres
--

SELECT pg_catalog.setval('master.skill_template_skte_id_seq', 1, false);


--
-- Name: transaction_payment_trpa_id_seq; Type: SEQUENCE SET; Schema: payment; Owner: postgres
--

SELECT pg_catalog.setval('payment.transaction_payment_trpa_id_seq', 1, false);


--
-- Name: cart_items_cait_id_seq; Type: SEQUENCE SET; Schema: sales; Owner: postgres
--

SELECT pg_catalog.setval('sales.cart_items_cait_id_seq', 1, false);


--
-- Name: sales_order_detail_sode_id_seq; Type: SEQUENCE SET; Schema: sales; Owner: postgres
--

SELECT pg_catalog.setval('sales.sales_order_detail_sode_id_seq', 1, false);


--
-- Name: sales_order_header_sohe_id_seq; Type: SEQUENCE SET; Schema: sales; Owner: postgres
--

SELECT pg_catalog.setval('sales.sales_order_header_sohe_id_seq', 1, false);


--
-- Name: special_offer_programs_soco_id_seq; Type: SEQUENCE SET; Schema: sales; Owner: postgres
--

SELECT pg_catalog.setval('sales.special_offer_programs_soco_id_seq', 1, false);


--
-- Name: special_offer_spof_id_seq; Type: SEQUENCE SET; Schema: sales; Owner: postgres
--

SELECT pg_catalog.setval('sales.special_offer_spof_id_seq', 1, false);


--
-- Name: business_entity_entity_id_seq; Type: SEQUENCE SET; Schema: users; Owner: postgres
--

SELECT pg_catalog.setval('users.business_entity_entity_id_seq', 1, false);


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: users; Owner: postgres
--

SELECT pg_catalog.setval('users.roles_role_id_seq', 1, false);


--
-- Name: users_education_usdu_id_seq; Type: SEQUENCE SET; Schema: users; Owner: postgres
--

SELECT pg_catalog.setval('users.users_education_usdu_id_seq', 1, false);


--
-- Name: users_email_pmail_id_seq; Type: SEQUENCE SET; Schema: users; Owner: postgres
--

SELECT pg_catalog.setval('users.users_email_pmail_id_seq', 1, false);


--
-- Name: users_experiences_usex_id_seq; Type: SEQUENCE SET; Schema: users; Owner: postgres
--

SELECT pg_catalog.setval('users.users_experiences_usex_id_seq', 1, false);


--
-- Name: users_license_usli_id_seq; Type: SEQUENCE SET; Schema: users; Owner: postgres
--

SELECT pg_catalog.setval('users.users_license_usli_id_seq', 1, false);


--
-- Name: users_media_usme_id_seq; Type: SEQUENCE SET; Schema: users; Owner: postgres
--

SELECT pg_catalog.setval('users.users_media_usme_id_seq', 1, false);


--
-- Name: users_skill_uski_id_seq; Type: SEQUENCE SET; Schema: users; Owner: postgres
--

SELECT pg_catalog.setval('users.users_skill_uski_id_seq', 1, false);


--
-- Name: batch batch_batch_name_key; Type: CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch
    ADD CONSTRAINT batch_batch_name_key UNIQUE (batch_name);


--
-- Name: batch batch_entity_unique_id; Type: CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch
    ADD CONSTRAINT batch_entity_unique_id UNIQUE (batch_entity_id);


--
-- Name: batch batch_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch
    ADD CONSTRAINT batch_pkey PRIMARY KEY (batch_id, batch_entity_id);


--
-- Name: batch_trainee_evaluation batch_trainee_evaluation_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch_trainee_evaluation
    ADD CONSTRAINT batch_trainee_evaluation_pkey PRIMARY KEY (btev_id);


--
-- Name: batch_trainee batch_trainee_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch_trainee
    ADD CONSTRAINT batch_trainee_pkey PRIMARY KEY (batr_id, batr_batch_id);


--
-- Name: batch batch_unique_id; Type: CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch
    ADD CONSTRAINT batch_unique_id UNIQUE (batch_id);


--
-- Name: instructor_programs instructor_programs_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.instructor_programs
    ADD CONSTRAINT instructor_programs_pkey PRIMARY KEY (inpro_batch_id, inpro_entity_id, inpro_emp_entity_id);


--
-- Name: program_apply program_apply_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.program_apply
    ADD CONSTRAINT program_apply_pkey PRIMARY KEY (prap_user_entity_id, prap_prog_entity_id);


--
-- Name: program_apply_progress program_apply_progress_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.program_apply_progress
    ADD CONSTRAINT program_apply_progress_pkey PRIMARY KEY (parog_id);


--
-- Name: talents talents_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.talents
    ADD CONSTRAINT talents_pkey PRIMARY KEY (talent_id);


--
-- Name: program_entity_description program_entity_description_pkey; Type: CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.program_entity_description
    ADD CONSTRAINT program_entity_description_pkey PRIMARY KEY (pred_prog_entity_id);


--
-- Name: program_entity program_entity_pkey; Type: CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.program_entity
    ADD CONSTRAINT program_entity_pkey PRIMARY KEY (prog_entity_id);


--
-- Name: program_reviews program_reviews_pkey; Type: CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.program_reviews
    ADD CONSTRAINT program_reviews_pkey PRIMARY KEY (prow_user_entity_id, prow_prog_entity_id);


--
-- Name: section_detail_material section_detail_material_pkey; Type: CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.section_detail_material
    ADD CONSTRAINT section_detail_material_pkey PRIMARY KEY (sedm_id);


--
-- Name: section_detail section_detail_pkey; Type: CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.section_detail
    ADD CONSTRAINT section_detail_pkey PRIMARY KEY (secd_id);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (sect_id, sect_prog_entity_id);


--
-- Name: sections sections_sect_id_key; Type: CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.sections
    ADD CONSTRAINT sections_sect_id_key UNIQUE (sect_id);


--
-- Name: department department_dept_name_key; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.department
    ADD CONSTRAINT department_dept_name_key UNIQUE (dept_name);


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (dept_id);


--
-- Name: employee_department_history employee_department_history_pkey; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee_department_history
    ADD CONSTRAINT employee_department_history_pkey PRIMARY KEY (edhi_id, edhi_entity_id);


--
-- Name: employee employee_emp_emp_number_key; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee
    ADD CONSTRAINT employee_emp_emp_number_key UNIQUE (emp_emp_number);


--
-- Name: employee employee_emp_national_id_key; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee
    ADD CONSTRAINT employee_emp_national_id_key UNIQUE (emp_national_id);


--
-- Name: employee_pay_history employee_pay_history_pkey; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee_pay_history
    ADD CONSTRAINT employee_pay_history_pkey PRIMARY KEY (ephi_entity_id, ephi_rate_change_date);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (emp_entity_id);


--
-- Name: client client_clit_name_key; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.client
    ADD CONSTRAINT client_clit_name_key UNIQUE (clit_name);


--
-- Name: client client_pkey; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (clit_id);


--
-- Name: employee_range employee_range_emra_range_max_key; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.employee_range
    ADD CONSTRAINT employee_range_emra_range_max_key UNIQUE (emra_range_max);


--
-- Name: employee_range employee_range_emra_range_min_key; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.employee_range
    ADD CONSTRAINT employee_range_emra_range_min_key UNIQUE (emra_range_min);


--
-- Name: employee_range employee_range_pkey; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.employee_range
    ADD CONSTRAINT employee_range_pkey PRIMARY KEY (emra_id);


--
-- Name: job_category job_category_pkey; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_category
    ADD CONSTRAINT job_category_pkey PRIMARY KEY (joca_id);


--
-- Name: job_photo job_photo_pkey; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_photo
    ADD CONSTRAINT job_photo_pkey PRIMARY KEY (jopho_id);


--
-- Name: job_post_desc job_post_desc_pkey; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post_desc
    ADD CONSTRAINT job_post_desc_pkey PRIMARY KEY (jopo_entity_id);


--
-- Name: job_post job_post_jopo_number_key; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_number_key UNIQUE (jopo_number);


--
-- Name: job_post job_post_pkey; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_pkey PRIMARY KEY (jopo_entity_id);


--
-- Name: talent_apply talent_apply_pkey; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.talent_apply
    ADD CONSTRAINT talent_apply_pkey PRIMARY KEY (taap_user_entity_id, taap_entity_id);


--
-- Name: talent_apply_progress talent_apply_progress_pkey; Type: CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.talent_apply_progress
    ADD CONSTRAINT talent_apply_progress_pkey PRIMARY KEY (tapr_id, tapr_taap_user_entity_id, tapr_taap_entity_id);


--
-- Name: address address_addr_line1_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.address
    ADD CONSTRAINT address_addr_line1_key UNIQUE (addr_line1);


--
-- Name: address address_addr_line2_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.address
    ADD CONSTRAINT address_addr_line2_key UNIQUE (addr_line2);


--
-- Name: address address_addr_postal_code_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.address
    ADD CONSTRAINT address_addr_postal_code_key UNIQUE (addr_postal_code);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (addr_id);


--
-- Name: address_type address_type_adty_name_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.address_type
    ADD CONSTRAINT address_type_adty_name_key UNIQUE (adty_name);


--
-- Name: address_type address_type_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.address_type
    ADD CONSTRAINT address_type_pkey PRIMARY KEY (adty_id);


--
-- Name: category category_cate_name_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.category
    ADD CONSTRAINT category_cate_name_key UNIQUE (cate_name);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (cate_id);


--
-- Name: city city_city_name_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.city
    ADD CONSTRAINT city_city_name_key UNIQUE (city_name);


--
-- Name: city city_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (city_id);


--
-- Name: country country_country_name_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.country
    ADD CONSTRAINT country_country_name_key UNIQUE (country_name);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_code);


--
-- Name: education education_edu_name_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.education
    ADD CONSTRAINT education_edu_name_key UNIQUE (edu_name);


--
-- Name: education education_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.education
    ADD CONSTRAINT education_pkey PRIMARY KEY (edu_code);


--
-- Name: industry industry_indu_name_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.industry
    ADD CONSTRAINT industry_indu_name_key UNIQUE (indu_name);


--
-- Name: industry industry_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.industry
    ADD CONSTRAINT industry_pkey PRIMARY KEY (indu_code);


--
-- Name: job_role job_role_joro_name_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.job_role
    ADD CONSTRAINT job_role_joro_name_key UNIQUE (joro_name);


--
-- Name: job_role job_role_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.job_role
    ADD CONSTRAINT job_role_pkey PRIMARY KEY (joro_id);


--
-- Name: job_type job_type_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.job_type
    ADD CONSTRAINT job_type_pkey PRIMARY KEY (joty_id);


--
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (module_name);


--
-- Name: province province_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.province
    ADD CONSTRAINT province_pkey PRIMARY KEY (prov_id);


--
-- Name: province province_prov_code_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.province
    ADD CONSTRAINT province_prov_code_key UNIQUE (prov_code);


--
-- Name: route_actions route_actions_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.route_actions
    ADD CONSTRAINT route_actions_pkey PRIMARY KEY (roac_id);


--
-- Name: route_actions route_actions_roac_name_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.route_actions
    ADD CONSTRAINT route_actions_roac_name_key UNIQUE (roac_name);


--
-- Name: skill_template skill_template_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.skill_template
    ADD CONSTRAINT skill_template_pkey PRIMARY KEY (skte_id);


--
-- Name: skill_type skill_type_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.skill_type
    ADD CONSTRAINT skill_type_pkey PRIMARY KEY (skty_name);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (status);


--
-- Name: working_type working_code_pkey; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.working_type
    ADD CONSTRAINT working_code_pkey PRIMARY KEY (woty_code);


--
-- Name: working_type working_type_woty_name_key; Type: CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.working_type
    ADD CONSTRAINT working_type_woty_name_key UNIQUE (woty_name);


--
-- Name: bank bank_bank_code_key; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.bank
    ADD CONSTRAINT bank_bank_code_key UNIQUE (bank_code);


--
-- Name: bank bank_bank_name_key; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.bank
    ADD CONSTRAINT bank_bank_name_key UNIQUE (bank_name);


--
-- Name: bank bank_pkey; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (bank_entity_id);


--
-- Name: fintech fintech_fint_code_key; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.fintech
    ADD CONSTRAINT fintech_fint_code_key UNIQUE (fint_code);


--
-- Name: fintech fintech_fint_name_key; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.fintech
    ADD CONSTRAINT fintech_fint_name_key UNIQUE (fint_name);


--
-- Name: fintech fintech_pkey; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.fintech
    ADD CONSTRAINT fintech_pkey PRIMARY KEY (fint_entity_id);


--
-- Name: transaction_payment transaction_payment_pkey; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.transaction_payment
    ADD CONSTRAINT transaction_payment_pkey PRIMARY KEY (trpa_id);


--
-- Name: transaction_payment transaction_payment_trpa_code_number_key; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.transaction_payment
    ADD CONSTRAINT transaction_payment_trpa_code_number_key UNIQUE (trpa_code_number);


--
-- Name: users_account users_account_pkey; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.users_account
    ADD CONSTRAINT users_account_pkey PRIMARY KEY (usac_user_entity_id, usac_bank_entity_id);


--
-- Name: users_account users_account_usac_account_number_key; Type: CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.users_account
    ADD CONSTRAINT users_account_usac_account_number_key UNIQUE (usac_account_number);


--
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (cait_id);


--
-- Name: sales_order_detail sales_order_detail_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.sales_order_detail
    ADD CONSTRAINT sales_order_detail_pkey PRIMARY KEY (sode_id);


--
-- Name: sales_order_header sales_order_header_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.sales_order_header
    ADD CONSTRAINT sales_order_header_pkey PRIMARY KEY (sohe_id);


--
-- Name: sales_order_header sales_order_header_sohe_license_code_key; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.sales_order_header
    ADD CONSTRAINT sales_order_header_sohe_license_code_key UNIQUE (sohe_license_code);


--
-- Name: sales_order_header sales_order_header_sohe_order_number_key; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.sales_order_header
    ADD CONSTRAINT sales_order_header_sohe_order_number_key UNIQUE (sohe_order_number);


--
-- Name: special_offer special_offer_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.special_offer
    ADD CONSTRAINT special_offer_pkey PRIMARY KEY (spof_id);


--
-- Name: special_offer_programs special_offer_programs_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.special_offer_programs
    ADD CONSTRAINT special_offer_programs_pkey PRIMARY KEY (soco_id, soco_spof_id, soco_prog_entity_id);


--
-- Name: special_offer_programs special_offer_programs_soco_id_key; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.special_offer_programs
    ADD CONSTRAINT special_offer_programs_soco_id_key UNIQUE (soco_id);


--
-- Name: business_entity business_entity_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.business_entity
    ADD CONSTRAINT business_entity_pkey PRIMARY KEY (entity_id);


--
-- Name: phone_number_type phone_number_type_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.phone_number_type
    ADD CONSTRAINT phone_number_type_pkey PRIMARY KEY (ponty_code);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: users_address users_address_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_address
    ADD CONSTRAINT users_address_pkey PRIMARY KEY (etad_addr_id);


--
-- Name: users_education users_education_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_education
    ADD CONSTRAINT users_education_pkey PRIMARY KEY (usdu_id, usdu_entity_id);


--
-- Name: users_email users_email_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_email
    ADD CONSTRAINT users_email_pkey PRIMARY KEY (pmail_entity_id, pmail_id);


--
-- Name: users_experiences users_experiences_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_experiences
    ADD CONSTRAINT users_experiences_pkey PRIMARY KEY (usex_id, usex_entity_id);


--
-- Name: users_experiences_skill users_experiences_skill_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_experiences_skill
    ADD CONSTRAINT users_experiences_skill_pkey PRIMARY KEY (uesk_usex_id, uesk_uski_id);


--
-- Name: users_experiences users_experiences_usex_id_key; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_experiences
    ADD CONSTRAINT users_experiences_usex_id_key UNIQUE (usex_id);


--
-- Name: users_license users_license_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_license
    ADD CONSTRAINT users_license_pkey PRIMARY KEY (usli_id, usli_entity_id);


--
-- Name: users_license users_license_usli_license_code_key; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_license
    ADD CONSTRAINT users_license_usli_license_code_key UNIQUE (usli_license_code);


--
-- Name: users_media users_media_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_media
    ADD CONSTRAINT users_media_pkey PRIMARY KEY (usme_id, usme_entity_id);


--
-- Name: users_phones users_phones_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_phones
    ADD CONSTRAINT users_phones_pkey PRIMARY KEY (uspo_entity_id, uspo_number);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_entity_id);


--
-- Name: users_roles users_roles_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_roles
    ADD CONSTRAINT users_roles_pkey PRIMARY KEY (usro_entity_id, usro_role_id);


--
-- Name: users_skill users_skill_pkey; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_skill
    ADD CONSTRAINT users_skill_pkey PRIMARY KEY (uski_id, uski_entity_id);


--
-- Name: users_skill users_skill_uski_id_key; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_skill
    ADD CONSTRAINT users_skill_uski_id_key UNIQUE (uski_id);


--
-- Name: users users_user_name_key; Type: CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users
    ADD CONSTRAINT users_user_name_key UNIQUE (user_name);


--
-- Name: batch batch_batch_entity_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch
    ADD CONSTRAINT batch_batch_entity_id_fkey FOREIGN KEY (batch_entity_id) REFERENCES curriculum.program_entity(prog_entity_id);


--
-- Name: batch batch_batch_pic_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch
    ADD CONSTRAINT batch_batch_pic_id_fkey FOREIGN KEY (batch_pic_id) REFERENCES hr.employee(emp_entity_id);


--
-- Name: batch batch_batch_status_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch
    ADD CONSTRAINT batch_batch_status_fkey FOREIGN KEY (batch_status) REFERENCES master.status(status);


--
-- Name: batch_trainee batch_trainee_batr_batch_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch_trainee
    ADD CONSTRAINT batch_trainee_batr_batch_id_fkey FOREIGN KEY (batr_batch_id) REFERENCES bootcamp.batch(batch_id);


--
-- Name: batch_trainee batch_trainee_batr_status_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch_trainee
    ADD CONSTRAINT batch_trainee_batr_status_fkey FOREIGN KEY (batr_status) REFERENCES master.status(status);


--
-- Name: batch_trainee batch_trainee_batr_trainee_entity_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch_trainee
    ADD CONSTRAINT batch_trainee_batr_trainee_entity_id_fkey FOREIGN KEY (batr_trainee_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: batch_trainee_evaluation batch_trainee_evaluation_btev_batch_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch_trainee_evaluation
    ADD CONSTRAINT batch_trainee_evaluation_btev_batch_id_fkey FOREIGN KEY (btev_batch_id) REFERENCES bootcamp.batch(batch_id);


--
-- Name: batch_trainee_evaluation batch_trainee_evaluation_btev_trainee_entity_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.batch_trainee_evaluation
    ADD CONSTRAINT batch_trainee_evaluation_btev_trainee_entity_id_fkey FOREIGN KEY (btev_trainee_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: instructor_programs instructor_programs_inpro_batch_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.instructor_programs
    ADD CONSTRAINT instructor_programs_inpro_batch_id_fkey FOREIGN KEY (inpro_batch_id) REFERENCES bootcamp.batch(batch_id);


--
-- Name: instructor_programs instructor_programs_inpro_emp_entity_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.instructor_programs
    ADD CONSTRAINT instructor_programs_inpro_emp_entity_id_fkey FOREIGN KEY (inpro_emp_entity_id) REFERENCES hr.employee(emp_entity_id);


--
-- Name: instructor_programs instructor_programs_inpro_entity_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.instructor_programs
    ADD CONSTRAINT instructor_programs_inpro_entity_id_fkey FOREIGN KEY (inpro_entity_id) REFERENCES bootcamp.batch(batch_entity_id);


--
-- Name: program_apply program_apply_prap_prog_entity_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.program_apply
    ADD CONSTRAINT program_apply_prap_prog_entity_id_fkey FOREIGN KEY (prap_prog_entity_id) REFERENCES curriculum.program_entity(prog_entity_id);


--
-- Name: program_apply program_apply_prap_status_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.program_apply
    ADD CONSTRAINT program_apply_prap_status_fkey FOREIGN KEY (prap_status) REFERENCES master.status(status);


--
-- Name: program_apply program_apply_prap_user_entity_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.program_apply
    ADD CONSTRAINT program_apply_prap_user_entity_id_fkey FOREIGN KEY (prap_user_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: program_apply_progress program_apply_progress_parog_progress_name_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.program_apply_progress
    ADD CONSTRAINT program_apply_progress_parog_progress_name_fkey FOREIGN KEY (parog_progress_name) REFERENCES master.route_actions(roac_name);


--
-- Name: program_apply_progress program_apply_progress_parog_status_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.program_apply_progress
    ADD CONSTRAINT program_apply_progress_parog_status_fkey FOREIGN KEY (parog_status) REFERENCES master.status(status);


--
-- Name: program_apply_progress program_apply_progress_parog_user_entity_id_parog_prog_ent_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.program_apply_progress
    ADD CONSTRAINT program_apply_progress_parog_user_entity_id_parog_prog_ent_fkey FOREIGN KEY (parog_user_entity_id, parog_prog_entity_id) REFERENCES bootcamp.program_apply(prap_user_entity_id, prap_prog_entity_id);


--
-- Name: talents talents_talent_batch_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.talents
    ADD CONSTRAINT talents_talent_batch_id_fkey FOREIGN KEY (talent_batch_id) REFERENCES bootcamp.batch(batch_id);


--
-- Name: talents talents_talent_user_entity_id_fkey; Type: FK CONSTRAINT; Schema: bootcamp; Owner: postgres
--

ALTER TABLE ONLY bootcamp.talents
    ADD CONSTRAINT talents_talent_user_entity_id_fkey FOREIGN KEY (talent_user_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: program_entity_description program_entity_description_pred_prog_entity_id_fkey; Type: FK CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.program_entity_description
    ADD CONSTRAINT program_entity_description_pred_prog_entity_id_fkey FOREIGN KEY (pred_prog_entity_id) REFERENCES curriculum.program_entity(prog_entity_id);


--
-- Name: program_entity program_entity_prog_cate_id_fkey; Type: FK CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.program_entity
    ADD CONSTRAINT program_entity_prog_cate_id_fkey FOREIGN KEY (prog_cate_id) REFERENCES master.category(cate_id);


--
-- Name: program_entity program_entity_prog_city_id_fkey; Type: FK CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.program_entity
    ADD CONSTRAINT program_entity_prog_city_id_fkey FOREIGN KEY (prog_city_id) REFERENCES master.city(city_id);


--
-- Name: program_entity program_entity_prog_created_by_fkey; Type: FK CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.program_entity
    ADD CONSTRAINT program_entity_prog_created_by_fkey FOREIGN KEY (prog_created_by) REFERENCES hr.employee(emp_entity_id);


--
-- Name: program_entity program_entity_prog_entity_id_fkey; Type: FK CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.program_entity
    ADD CONSTRAINT program_entity_prog_entity_id_fkey FOREIGN KEY (prog_entity_id) REFERENCES users.business_entity(entity_id);


--
-- Name: program_reviews program_reviews_prow_prog_entity_id_fkey; Type: FK CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.program_reviews
    ADD CONSTRAINT program_reviews_prow_prog_entity_id_fkey FOREIGN KEY (prow_prog_entity_id) REFERENCES curriculum.program_entity(prog_entity_id);


--
-- Name: program_reviews program_reviews_prow_user_entity_id_fkey; Type: FK CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.program_reviews
    ADD CONSTRAINT program_reviews_prow_user_entity_id_fkey FOREIGN KEY (prow_user_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: section_detail_material section_detail_material_sedm_secd_id_fkey; Type: FK CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.section_detail_material
    ADD CONSTRAINT section_detail_material_sedm_secd_id_fkey FOREIGN KEY (sedm_secd_id) REFERENCES curriculum.section_detail(secd_id);


--
-- Name: section_detail section_detail_secd_sect_id_fkey; Type: FK CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.section_detail
    ADD CONSTRAINT section_detail_secd_sect_id_fkey FOREIGN KEY (secd_sect_id) REFERENCES curriculum.sections(sect_id);


--
-- Name: sections sections_sect_prog_entity_id_fkey; Type: FK CONSTRAINT; Schema: curriculum; Owner: postgres
--

ALTER TABLE ONLY curriculum.sections
    ADD CONSTRAINT sections_sect_prog_entity_id_fkey FOREIGN KEY (sect_prog_entity_id) REFERENCES curriculum.program_entity(prog_entity_id);


--
-- Name: employee_department_history employee_department_history_edhi_dept_id_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee_department_history
    ADD CONSTRAINT employee_department_history_edhi_dept_id_fkey FOREIGN KEY (edhi_dept_id) REFERENCES hr.department(dept_id);


--
-- Name: employee_department_history employee_department_history_edhi_entity_id_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee_department_history
    ADD CONSTRAINT employee_department_history_edhi_entity_id_fkey FOREIGN KEY (edhi_entity_id) REFERENCES hr.employee(emp_entity_id);


--
-- Name: employee employee_emp_emp_entity_id_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee
    ADD CONSTRAINT employee_emp_emp_entity_id_fkey FOREIGN KEY (emp_emp_entity_id) REFERENCES hr.employee(emp_entity_id);


--
-- Name: employee employee_emp_entity_id_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee
    ADD CONSTRAINT employee_emp_entity_id_fkey FOREIGN KEY (emp_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: employee employee_emp_joro_id_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee
    ADD CONSTRAINT employee_emp_joro_id_fkey FOREIGN KEY (emp_joro_id) REFERENCES master.job_role(joro_id);


--
-- Name: employee_pay_history employee_pay_history_ephi_entity_id_fkey; Type: FK CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employee_pay_history
    ADD CONSTRAINT employee_pay_history_ephi_entity_id_fkey FOREIGN KEY (ephi_entity_id) REFERENCES hr.employee(emp_entity_id);


--
-- Name: client client_clit_addr_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.client
    ADD CONSTRAINT client_clit_addr_id_fkey FOREIGN KEY (clit_addr_id) REFERENCES master.address(addr_id);


--
-- Name: client client_clit_emra_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.client
    ADD CONSTRAINT client_clit_emra_id_fkey FOREIGN KEY (clit_emra_id) REFERENCES job_hire.employee_range(emra_id);


--
-- Name: job_photo job_photo_jopho_entity_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_photo
    ADD CONSTRAINT job_photo_jopho_entity_id_fkey FOREIGN KEY (jopho_entity_id) REFERENCES job_hire.job_post(jopo_entity_id);


--
-- Name: job_post_desc job_post_desc_jopo_entity_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post_desc
    ADD CONSTRAINT job_post_desc_jopo_entity_id_fkey FOREIGN KEY (jopo_entity_id) REFERENCES job_hire.job_post(jopo_entity_id);


--
-- Name: job_post job_post_jopo_addr_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_addr_id_fkey FOREIGN KEY (jopo_addr_id) REFERENCES master.address(addr_id);


--
-- Name: job_post job_post_jopo_clit_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_clit_id_fkey FOREIGN KEY (jopo_clit_id) REFERENCES job_hire.client(clit_id);


--
-- Name: job_post job_post_jopo_edu_code_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_edu_code_fkey FOREIGN KEY (jopo_edu_code) REFERENCES master.education(edu_code);


--
-- Name: job_post job_post_jopo_emp_entity_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_emp_entity_id_fkey FOREIGN KEY (jopo_emp_entity_id) REFERENCES hr.employee(emp_entity_id);


--
-- Name: job_post job_post_jopo_entity_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_entity_id_fkey FOREIGN KEY (jopo_entity_id) REFERENCES users.business_entity(entity_id);


--
-- Name: job_post job_post_jopo_indu_code_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_indu_code_fkey FOREIGN KEY (jopo_indu_code) REFERENCES master.industry(indu_code);


--
-- Name: job_post job_post_jopo_joca_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_joca_id_fkey FOREIGN KEY (jopo_joca_id) REFERENCES job_hire.job_category(joca_id);


--
-- Name: job_post job_post_jopo_joro_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_joro_id_fkey FOREIGN KEY (jopo_joro_id) REFERENCES master.job_role(joro_id);


--
-- Name: job_post job_post_jopo_joty_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_joty_id_fkey FOREIGN KEY (jopo_joty_id) REFERENCES master.job_type(joty_id);


--
-- Name: job_post job_post_jopo_status_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_status_fkey FOREIGN KEY (jopo_status) REFERENCES master.status(status);


--
-- Name: job_post job_post_jopo_work_code_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.job_post
    ADD CONSTRAINT job_post_jopo_work_code_fkey FOREIGN KEY (jopo_work_code) REFERENCES master.working_type(woty_code);


--
-- Name: talent_apply_progress talent_apply_progress_tapr_status_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.talent_apply_progress
    ADD CONSTRAINT talent_apply_progress_tapr_status_fkey FOREIGN KEY (tapr_status) REFERENCES master.status(status);


--
-- Name: talent_apply_progress talent_apply_progress_tapr_taap_user_entity_id_tapr_taap_e_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.talent_apply_progress
    ADD CONSTRAINT talent_apply_progress_tapr_taap_user_entity_id_tapr_taap_e_fkey FOREIGN KEY (tapr_taap_user_entity_id, tapr_taap_entity_id) REFERENCES job_hire.talent_apply(taap_user_entity_id, taap_entity_id);


--
-- Name: talent_apply talent_apply_taap_entity_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.talent_apply
    ADD CONSTRAINT talent_apply_taap_entity_id_fkey FOREIGN KEY (taap_entity_id) REFERENCES job_hire.job_post(jopo_entity_id);


--
-- Name: talent_apply talent_apply_taap_status_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.talent_apply
    ADD CONSTRAINT talent_apply_taap_status_fkey FOREIGN KEY (taap_status) REFERENCES master.status(status);


--
-- Name: talent_apply talent_apply_taap_user_entity_id_fkey; Type: FK CONSTRAINT; Schema: job_hire; Owner: postgres
--

ALTER TABLE ONLY job_hire.talent_apply
    ADD CONSTRAINT talent_apply_taap_user_entity_id_fkey FOREIGN KEY (taap_user_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: address addr_city_id; Type: FK CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.address
    ADD CONSTRAINT addr_city_id FOREIGN KEY (addr_city_id) REFERENCES master.city(city_id);


--
-- Name: category category_cate_cate_id_fkey; Type: FK CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.category
    ADD CONSTRAINT category_cate_cate_id_fkey FOREIGN KEY (cate_cate_id) REFERENCES master.category(cate_id);


--
-- Name: city city_city_prov_id_fkey; Type: FK CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.city
    ADD CONSTRAINT city_city_prov_id_fkey FOREIGN KEY (city_prov_id) REFERENCES master.province(prov_id);


--
-- Name: province prov_country_code; Type: FK CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.province
    ADD CONSTRAINT prov_country_code FOREIGN KEY (prov_country_code) REFERENCES master.country(country_code);


--
-- Name: route_actions roac_module_name; Type: FK CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.route_actions
    ADD CONSTRAINT roac_module_name FOREIGN KEY (roac_module_name) REFERENCES master.modules(module_name);


--
-- Name: skill_template skill_template_skte_skte_id_fkey; Type: FK CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.skill_template
    ADD CONSTRAINT skill_template_skte_skte_id_fkey FOREIGN KEY (skte_skte_id) REFERENCES master.skill_template(skte_id);


--
-- Name: skill_template skill_template_skty_name_fkey; Type: FK CONSTRAINT; Schema: master; Owner: postgres
--

ALTER TABLE ONLY master.skill_template
    ADD CONSTRAINT skill_template_skty_name_fkey FOREIGN KEY (skty_name) REFERENCES master.skill_type(skty_name);


--
-- Name: bank bank_bank_entity_id_fkey; Type: FK CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.bank
    ADD CONSTRAINT bank_bank_entity_id_fkey FOREIGN KEY (bank_entity_id) REFERENCES users.business_entity(entity_id);


--
-- Name: fintech fintech_fint_entity_id_fkey; Type: FK CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.fintech
    ADD CONSTRAINT fintech_fint_entity_id_fkey FOREIGN KEY (fint_entity_id) REFERENCES users.business_entity(entity_id);


--
-- Name: transaction_payment transaction_payment_trpa_user_entity_id_fkey; Type: FK CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.transaction_payment
    ADD CONSTRAINT transaction_payment_trpa_user_entity_id_fkey FOREIGN KEY (trpa_user_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: users_account users_account_usac_bank_entity_id_fkey; Type: FK CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.users_account
    ADD CONSTRAINT users_account_usac_bank_entity_id_fkey FOREIGN KEY (usac_bank_entity_id) REFERENCES payment.bank(bank_entity_id);


--
-- Name: users_account users_account_usac_fint_entity_id_fkey; Type: FK CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.users_account
    ADD CONSTRAINT users_account_usac_fint_entity_id_fkey FOREIGN KEY (usac_fint_entity_id) REFERENCES payment.fintech(fint_entity_id);


--
-- Name: users_account users_account_usac_user_entity_id_fkey; Type: FK CONSTRAINT; Schema: payment; Owner: postgres
--

ALTER TABLE ONLY payment.users_account
    ADD CONSTRAINT users_account_usac_user_entity_id_fkey FOREIGN KEY (usac_user_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: cart_items cart_items_cait_prog_entity_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.cart_items
    ADD CONSTRAINT cart_items_cait_prog_entity_id_fkey FOREIGN KEY (cait_prog_entity_id) REFERENCES curriculum.program_entity(prog_entity_id);


--
-- Name: cart_items cart_items_cait_user_entity_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.cart_items
    ADD CONSTRAINT cart_items_cait_user_entity_id_fkey FOREIGN KEY (cait_user_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: sales_order_detail sales_order_detail_sode_prog_entity_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.sales_order_detail
    ADD CONSTRAINT sales_order_detail_sode_prog_entity_id_fkey FOREIGN KEY (sode_prog_entity_id) REFERENCES curriculum.program_entity(prog_entity_id);


--
-- Name: sales_order_detail sales_order_detail_sode_soco_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.sales_order_detail
    ADD CONSTRAINT sales_order_detail_sode_soco_id_fkey FOREIGN KEY (sode_soco_id) REFERENCES sales.special_offer_programs(soco_id);


--
-- Name: sales_order_detail sales_order_detail_sode_sohe_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.sales_order_detail
    ADD CONSTRAINT sales_order_detail_sode_sohe_id_fkey FOREIGN KEY (sode_sohe_id) REFERENCES sales.sales_order_header(sohe_id);


--
-- Name: sales_order_header sales_order_header_sohe_status_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.sales_order_header
    ADD CONSTRAINT sales_order_header_sohe_status_fkey FOREIGN KEY (sohe_status) REFERENCES master.status(status);


--
-- Name: sales_order_header sales_order_header_sohe_user_entity_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.sales_order_header
    ADD CONSTRAINT sales_order_header_sohe_user_entity_id_fkey FOREIGN KEY (sohe_user_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: special_offer_programs special_offer_programs_soco_prog_entity_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.special_offer_programs
    ADD CONSTRAINT special_offer_programs_soco_prog_entity_id_fkey FOREIGN KEY (soco_prog_entity_id) REFERENCES curriculum.program_entity(prog_entity_id);


--
-- Name: special_offer_programs special_offer_programs_soco_spof_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.special_offer_programs
    ADD CONSTRAINT special_offer_programs_soco_spof_id_fkey FOREIGN KEY (soco_spof_id) REFERENCES sales.special_offer(spof_id);


--
-- Name: special_offer special_offer_spof_cate_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.special_offer
    ADD CONSTRAINT special_offer_spof_cate_id_fkey FOREIGN KEY (spof_cate_id) REFERENCES master.category(cate_id);


--
-- Name: users fk_users_current_role; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users
    ADD CONSTRAINT fk_users_current_role FOREIGN KEY (user_current_role, user_entity_id) REFERENCES users.users_roles(usro_role_id, usro_entity_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_address users_address_etad_addr_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_address
    ADD CONSTRAINT users_address_etad_addr_id_fkey FOREIGN KEY (etad_addr_id) REFERENCES master.address(addr_id);


--
-- Name: users_address users_address_etad_adty_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_address
    ADD CONSTRAINT users_address_etad_adty_id_fkey FOREIGN KEY (etad_adty_id) REFERENCES master.address_type(adty_id);


--
-- Name: users_address users_address_etad_entity_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_address
    ADD CONSTRAINT users_address_etad_entity_id_fkey FOREIGN KEY (etad_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: users_education users_education_usdu_entity_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_education
    ADD CONSTRAINT users_education_usdu_entity_id_fkey FOREIGN KEY (usdu_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: users_email users_email_pmail_entity_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_email
    ADD CONSTRAINT users_email_pmail_entity_id_fkey FOREIGN KEY (pmail_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: users_experiences_skill users_experiences_skill_uesk_usex_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_experiences_skill
    ADD CONSTRAINT users_experiences_skill_uesk_usex_id_fkey FOREIGN KEY (uesk_usex_id) REFERENCES users.users_experiences(usex_id);


--
-- Name: users_experiences_skill users_experiences_skill_uesk_uski_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_experiences_skill
    ADD CONSTRAINT users_experiences_skill_uesk_uski_id_fkey FOREIGN KEY (uesk_uski_id) REFERENCES users.users_skill(uski_id);


--
-- Name: users_experiences users_experiences_usex_city_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_experiences
    ADD CONSTRAINT users_experiences_usex_city_id_fkey FOREIGN KEY (usex_city_id) REFERENCES master.city(city_id);


--
-- Name: users_experiences users_experiences_usex_entity_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_experiences
    ADD CONSTRAINT users_experiences_usex_entity_id_fkey FOREIGN KEY (usex_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: users_license users_license_usli_entity_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_license
    ADD CONSTRAINT users_license_usli_entity_id_fkey FOREIGN KEY (usli_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: users_media users_media_usme_entity_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_media
    ADD CONSTRAINT users_media_usme_entity_id_fkey FOREIGN KEY (usme_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: users_phones users_phones_uspo_entity_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_phones
    ADD CONSTRAINT users_phones_uspo_entity_id_fkey FOREIGN KEY (uspo_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: users_phones users_phones_uspo_ponty_code_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_phones
    ADD CONSTRAINT users_phones_uspo_ponty_code_fkey FOREIGN KEY (uspo_ponty_code) REFERENCES users.phone_number_type(ponty_code);


--
-- Name: users_roles users_roles_usro_entity_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_roles
    ADD CONSTRAINT users_roles_usro_entity_id_fkey FOREIGN KEY (usro_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: users_roles users_roles_usro_role_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_roles
    ADD CONSTRAINT users_roles_usro_role_id_fkey FOREIGN KEY (usro_role_id) REFERENCES users.roles(role_id);


--
-- Name: users_skill users_skill_uski_entity_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_skill
    ADD CONSTRAINT users_skill_uski_entity_id_fkey FOREIGN KEY (uski_entity_id) REFERENCES users.users(user_entity_id);


--
-- Name: users_skill users_skill_uski_skty_name_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users_skill
    ADD CONSTRAINT users_skill_uski_skty_name_fkey FOREIGN KEY (uski_skty_name) REFERENCES master.skill_type(skty_name);


--
-- Name: users users_user_entity_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: postgres
--

ALTER TABLE ONLY users.users
    ADD CONSTRAINT users_user_entity_id_fkey FOREIGN KEY (user_entity_id) REFERENCES users.business_entity(entity_id);


--
-- PostgreSQL database dump complete
--

