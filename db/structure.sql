--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: intarray; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS intarray WITH SCHEMA public;


--
-- Name: EXTENSION intarray; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION intarray IS 'functions, operators, and index support for 1-D arrays of integers';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities (
    id integer NOT NULL,
    text text,
    type character varying(255),
    challenge_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying(255)
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admins (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    failed_attempts integer DEFAULT 0,
    unlock_token character varying(255),
    locked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: authentications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authentications (
    id integer NOT NULL,
    user_id integer,
    provider character varying(255),
    uid character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    public_url character varying(255),
    oauth_token character varying(255)
);


--
-- Name: authentications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authentications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authentications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authentications_id_seq OWNED BY authentications.id;


--
-- Name: brigade_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE brigade_users (
    id integer NOT NULL,
    user_id integer,
    brigade_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: brigade_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE brigade_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brigade_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE brigade_users_id_seq OWNED BY brigade_users.id;


--
-- Name: brigades; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE brigades (
    id integer NOT NULL,
    description text,
    calendar_url character varying(500),
    slack_url character varying(255),
    github_url character varying(500),
    facebook_url character varying(500),
    twitter_url character varying(255),
    header_image_url character varying(500),
    user_id integer NOT NULL,
    deactivated boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    location_id integer NOT NULL
);


--
-- Name: brigades_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE brigades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brigades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE brigades_id_seq OWNED BY brigades.id;


--
-- Name: challenges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE challenges (
    id integer NOT NULL,
    title character varying(255),
    description text,
    creator_id integer,
    status character varying(255) DEFAULT 'open'::character varying,
    dataset_url character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    likes_counter integer DEFAULT 0,
    first_spec text,
    second_spec text,
    third_spec text,
    pitch character varying(255),
    additional_links text,
    avatar character varying(255),
    about text,
    organization_id integer,
    welcome_mail text,
    dataset_id character varying(255),
    entry_template_url character varying(255),
    infographic character varying(255),
    ideas_phase_due_on date,
    ideas_selection_phase_due_on date,
    prototypes_phase_due_on date,
    prize text,
    starts_on date,
    fourth_spec text,
    fifth_spec text,
    finish_on date,
    assessment_methodology character varying(255),
    evaluation_criteria text,
    evaluation_instructions text,
    evaluations_opened boolean DEFAULT true
);


--
-- Name: challenges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE challenges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: challenges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE challenges_id_seq OWNED BY challenges.id;


--
-- Name: collaborations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collaborations (
    id integer NOT NULL,
    user_id integer,
    challenge_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    member_id integer
);


--
-- Name: collaborations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collaborations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collaborations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collaborations_id_seq OWNED BY collaborations.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    commentable_id integer DEFAULT 0,
    commentable_type character varying(255) DEFAULT ''::character varying,
    body text DEFAULT ''::text,
    user_id integer DEFAULT 0 NOT NULL,
    parent_id integer,
    lft integer,
    rgt integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    votes_counter integer DEFAULT 0
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: datasets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE datasets (
    id integer NOT NULL,
    challenge_id integer,
    guid character varying(255),
    format character varying(255),
    title character varying(255),
    name character varying(255),
    notes character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE datasets_id_seq OWNED BY datasets.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0,
    attempts integer DEFAULT 0,
    handler text,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE entries (
    id integer NOT NULL,
    name character varying(255),
    live_demo_url character varying(255),
    description text,
    member_id integer,
    challenge_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    technologies text,
    public boolean DEFAULT false NOT NULL,
    image character varying(255),
    accepted boolean,
    idea_url character varying(255),
    repo_url character varying(255),
    demo_url character varying(255),
    winner integer,
    is_valid boolean DEFAULT true,
    invalid_reason text
);


--
-- Name: entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entries_id_seq OWNED BY entries.id;


--
-- Name: evaluations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE evaluations (
    id integer NOT NULL,
    challenge_id integer,
    judge_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE evaluations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evaluations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE evaluations_id_seq OWNED BY evaluations.id;


--
-- Name: judges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE judges (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    company_name character varying(255)
);


--
-- Name: judges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE judges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE judges_id_seq OWNED BY judges.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    zip_code character varying(5) NOT NULL,
    state character varying(20) NOT NULL,
    city character varying(50) NOT NULL,
    locality character varying(50),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: members; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE members (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    phase_finish_reminder_setting boolean DEFAULT true NOT NULL
);


--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE members_id_seq OWNED BY members.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    accredited boolean DEFAULT false,
    accepting_subscribers boolean DEFAULT false,
    slug character varying(255)
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: report_cards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE report_cards (
    id integer NOT NULL,
    evaluation_id integer,
    entry_id integer,
    grades text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comments text,
    feedback text
);


--
-- Name: report_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE report_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: report_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE report_cards_id_seq OWNED BY report_cards.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: searches; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW searches AS
 SELECT locations.id AS searchable_id,
    locations.zip_code,
    locations.city,
    locations.state,
    locations.locality,
    'Location'::character varying AS searchable_type
   FROM locations;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    session_id character varying(255) NOT NULL,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skills (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skills_id_seq OWNED BY skills.id;


--
-- Name: subscribers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subscribers (
    id integer NOT NULL,
    email character varying(255),
    organization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscribers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscribers_id_seq OWNED BY subscribers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    avatar character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    nickname character varying(255),
    bio character varying(255),
    role character varying(255) DEFAULT 'member'::character varying,
    userable_type character varying(255),
    userable_id integer,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    website character varying(255),
    github_url character varying(255),
    twitter_url character varying(255),
    facebook_url character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: userskills; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE userskills (
    id integer NOT NULL,
    user_id integer,
    skill_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: userskills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE userskills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: userskills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE userskills_id_seq OWNED BY userskills.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer NOT NULL,
    vote boolean DEFAULT false NOT NULL,
    voteable_id integer NOT NULL,
    voteable_type character varying(255) NOT NULL,
    voter_id integer,
    voter_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY authentications ALTER COLUMN id SET DEFAULT nextval('authentications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY brigade_users ALTER COLUMN id SET DEFAULT nextval('brigade_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY brigades ALTER COLUMN id SET DEFAULT nextval('brigades_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY challenges ALTER COLUMN id SET DEFAULT nextval('challenges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collaborations ALTER COLUMN id SET DEFAULT nextval('collaborations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets ALTER COLUMN id SET DEFAULT nextval('datasets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY entries ALTER COLUMN id SET DEFAULT nextval('entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY evaluations ALTER COLUMN id SET DEFAULT nextval('evaluations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY judges ALTER COLUMN id SET DEFAULT nextval('judges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY members ALTER COLUMN id SET DEFAULT nextval('members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY report_cards ALTER COLUMN id SET DEFAULT nextval('report_cards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skills ALTER COLUMN id SET DEFAULT nextval('skills_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscribers ALTER COLUMN id SET DEFAULT nextval('subscribers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY userskills ALTER COLUMN id SET DEFAULT nextval('userskills_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: authentications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authentications
    ADD CONSTRAINT authentications_pkey PRIMARY KEY (id);


--
-- Name: brigade_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY brigade_users
    ADD CONSTRAINT brigade_users_pkey PRIMARY KEY (id);


--
-- Name: brigades_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY brigades
    ADD CONSTRAINT brigades_pkey PRIMARY KEY (id);


--
-- Name: collaborations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collaborations
    ADD CONSTRAINT collaborations_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY evaluations
    ADD CONSTRAINT evaluations_pkey PRIMARY KEY (id);


--
-- Name: judges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY judges
    ADD CONSTRAINT judges_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: members_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: org_suscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subscribers
    ADD CONSTRAINT org_suscribers_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY challenges
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: report_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY report_cards
    ADD CONSTRAINT report_cards_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: userskills_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY userskills
    ADD CONSTRAINT userskills_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: fk_one_vote_per_user_per_entity; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX fk_one_vote_per_user_per_entity ON votes USING btree (voter_id, voter_type, voteable_id, voteable_type);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_email ON admins USING btree (email);


--
-- Name: index_authentications_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authentications_on_user_id ON authentications USING btree (user_id);


--
-- Name: index_brigade_users_on_brigade_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_brigade_users_on_brigade_id ON brigade_users USING btree (brigade_id);


--
-- Name: index_brigade_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_brigade_users_on_user_id ON brigade_users USING btree (user_id);


--
-- Name: index_brigades_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_brigades_on_user_id ON brigades USING btree (user_id);


--
-- Name: index_challenges_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_challenges_on_organization_id ON challenges USING btree (organization_id);


--
-- Name: index_collaborations_on_member_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collaborations_on_member_id ON collaborations USING btree (member_id);


--
-- Name: index_comments_on_commentable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_id ON comments USING btree (commentable_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_datasets_on_guid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_datasets_on_guid ON datasets USING btree (guid);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_session_id ON sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_updated_at ON sessions USING btree (updated_at);


--
-- Name: index_subscribers_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_subscribers_on_organization_id ON subscribers USING btree (organization_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_userable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_userable_id ON users USING btree (userable_id);


--
-- Name: index_users_on_userable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_userable_type ON users USING btree (userable_type);


--
-- Name: index_userskills_on_skill_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_userskills_on_skill_id ON userskills USING btree (skill_id);


--
-- Name: index_userskills_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_userskills_on_user_id ON userskills USING btree (user_id);


--
-- Name: index_votes_on_voteable_id_and_voteable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_voteable_id_and_voteable_type ON votes USING btree (voteable_id, voteable_type);


--
-- Name: index_votes_on_voter_id_and_voter_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_voter_id_and_voter_type ON votes USING btree (voter_id, voter_type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20121201201157');

INSERT INTO schema_migrations (version) VALUES ('20121201201337');

INSERT INTO schema_migrations (version) VALUES ('20121201202707');

INSERT INTO schema_migrations (version) VALUES ('20121201222626');

INSERT INTO schema_migrations (version) VALUES ('20121202010126');

INSERT INTO schema_migrations (version) VALUES ('20121202021152');

INSERT INTO schema_migrations (version) VALUES ('20121202023134');

INSERT INTO schema_migrations (version) VALUES ('20121202030142');

INSERT INTO schema_migrations (version) VALUES ('20121202042255');

INSERT INTO schema_migrations (version) VALUES ('20121202043719');

INSERT INTO schema_migrations (version) VALUES ('20121202072256');

INSERT INTO schema_migrations (version) VALUES ('20121202075141');

INSERT INTO schema_migrations (version) VALUES ('20121202140917');

INSERT INTO schema_migrations (version) VALUES ('20121202151106');

INSERT INTO schema_migrations (version) VALUES ('20121202174224');

INSERT INTO schema_migrations (version) VALUES ('20121202183347');

INSERT INTO schema_migrations (version) VALUES ('20121202220023');

INSERT INTO schema_migrations (version) VALUES ('20121202221258');

INSERT INTO schema_migrations (version) VALUES ('20121207182925');

INSERT INTO schema_migrations (version) VALUES ('20130321193850');

INSERT INTO schema_migrations (version) VALUES ('20130331232228');

INSERT INTO schema_migrations (version) VALUES ('20130406204325');

INSERT INTO schema_migrations (version) VALUES ('20130514151742');

INSERT INTO schema_migrations (version) VALUES ('20130514154455');

INSERT INTO schema_migrations (version) VALUES ('20130514164851');

INSERT INTO schema_migrations (version) VALUES ('20130514165716');

INSERT INTO schema_migrations (version) VALUES ('20130514193950');

INSERT INTO schema_migrations (version) VALUES ('20130521004604');

INSERT INTO schema_migrations (version) VALUES ('20130523180445');

INSERT INTO schema_migrations (version) VALUES ('20130531210015');

INSERT INTO schema_migrations (version) VALUES ('20130603031100');

INSERT INTO schema_migrations (version) VALUES ('20130603042440');

INSERT INTO schema_migrations (version) VALUES ('20130605183156');

INSERT INTO schema_migrations (version) VALUES ('20130624234153');

INSERT INTO schema_migrations (version) VALUES ('20130724213846');

INSERT INTO schema_migrations (version) VALUES ('20130725211603');

INSERT INTO schema_migrations (version) VALUES ('20131022220944');

INSERT INTO schema_migrations (version) VALUES ('20140122213528');

INSERT INTO schema_migrations (version) VALUES ('20140122223502');

INSERT INTO schema_migrations (version) VALUES ('20140128173653');

INSERT INTO schema_migrations (version) VALUES ('20140220153945');

INSERT INTO schema_migrations (version) VALUES ('20140422211314');

INSERT INTO schema_migrations (version) VALUES ('20140423161219');

INSERT INTO schema_migrations (version) VALUES ('20140424171432');

INSERT INTO schema_migrations (version) VALUES ('20140429165327');

INSERT INTO schema_migrations (version) VALUES ('20140430195726');

INSERT INTO schema_migrations (version) VALUES ('20140512214641');

INSERT INTO schema_migrations (version) VALUES ('20140513203424');

INSERT INTO schema_migrations (version) VALUES ('20140516170945');

INSERT INTO schema_migrations (version) VALUES ('20140617153428');

INSERT INTO schema_migrations (version) VALUES ('20140618180038');

INSERT INTO schema_migrations (version) VALUES ('20140619214705');

INSERT INTO schema_migrations (version) VALUES ('20140623193529');

INSERT INTO schema_migrations (version) VALUES ('20140623231210');

INSERT INTO schema_migrations (version) VALUES ('20140624175249');

INSERT INTO schema_migrations (version) VALUES ('20140624191444');

INSERT INTO schema_migrations (version) VALUES ('20140624200532');

INSERT INTO schema_migrations (version) VALUES ('20140624225834');

INSERT INTO schema_migrations (version) VALUES ('20140625211618');

INSERT INTO schema_migrations (version) VALUES ('20140630215255');

INSERT INTO schema_migrations (version) VALUES ('20140630221734');

INSERT INTO schema_migrations (version) VALUES ('20140702190651');

INSERT INTO schema_migrations (version) VALUES ('20140703214450');

INSERT INTO schema_migrations (version) VALUES ('20140709184823');

INSERT INTO schema_migrations (version) VALUES ('20140709191332');

INSERT INTO schema_migrations (version) VALUES ('20140715152028');

INSERT INTO schema_migrations (version) VALUES ('20140715163409');

INSERT INTO schema_migrations (version) VALUES ('20140716225335');

INSERT INTO schema_migrations (version) VALUES ('20140808005250');

INSERT INTO schema_migrations (version) VALUES ('20140817233616');

INSERT INTO schema_migrations (version) VALUES ('20140905160910');

INSERT INTO schema_migrations (version) VALUES ('20140922185334');

INSERT INTO schema_migrations (version) VALUES ('20141001162149');

INSERT INTO schema_migrations (version) VALUES ('20141029185347');

INSERT INTO schema_migrations (version) VALUES ('20141104200850');

INSERT INTO schema_migrations (version) VALUES ('20141104205822');

INSERT INTO schema_migrations (version) VALUES ('20141107211607');

INSERT INTO schema_migrations (version) VALUES ('20141210221854');

INSERT INTO schema_migrations (version) VALUES ('20150130203205');

INSERT INTO schema_migrations (version) VALUES ('20150203220334');

INSERT INTO schema_migrations (version) VALUES ('20150302002255');

INSERT INTO schema_migrations (version) VALUES ('20150304233131');

INSERT INTO schema_migrations (version) VALUES ('20150312152321');

INSERT INTO schema_migrations (version) VALUES ('20150318183807');

INSERT INTO schema_migrations (version) VALUES ('20150924200320');

INSERT INTO schema_migrations (version) VALUES ('20150924200950');

INSERT INTO schema_migrations (version) VALUES ('20150924201801');

INSERT INTO schema_migrations (version) VALUES ('20150924211443');

INSERT INTO schema_migrations (version) VALUES ('20150928235737');

INSERT INTO schema_migrations (version) VALUES ('20160309222636');

INSERT INTO schema_migrations (version) VALUES ('20160309232212');

INSERT INTO schema_migrations (version) VALUES ('20160311013534');

INSERT INTO schema_migrations (version) VALUES ('20160311063544');

INSERT INTO schema_migrations (version) VALUES ('20160311071451');

INSERT INTO schema_migrations (version) VALUES ('20160320175326');

INSERT INTO schema_migrations (version) VALUES ('20160320175502');

INSERT INTO schema_migrations (version) VALUES ('20160321003117');

INSERT INTO schema_migrations (version) VALUES ('20160330230458');

INSERT INTO schema_migrations (version) VALUES ('20160401184813');