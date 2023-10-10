--
-- Class Article as table article
--

CREATE TABLE "article" (
  "id" serial,
  "title" text NOT NULL,
  "content" text NOT NULL,
  "publishedOn" timestamp without time zone NOT NULL,
  "isPrime" boolean NOT NULL
);

ALTER TABLE ONLY "article"
  ADD CONSTRAINT article_pkey PRIMARY KEY (id);


--
-- Class LoginData as table logindata
--

CREATE TABLE "logindata" (
  "id" serial,
  "email" text NOT NULL,
  "password" text NOT NULL
);

ALTER TABLE ONLY "logindata"
  ADD CONSTRAINT logindata_pkey PRIMARY KEY (id);


--
-- Class UserData as table userdata
--

CREATE TABLE "userdata" (
  "id" serial,
  "username" text NOT NULL,
  "email" text NOT NULL,
  "password" text NOT NULL,
  "token" text
);

ALTER TABLE ONLY "userdata"
  ADD CONSTRAINT userdata_pkey PRIMARY KEY (id);


