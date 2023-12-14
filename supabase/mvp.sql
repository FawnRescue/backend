
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

CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";

CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."aircraft" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "owner" "uuid",
    "description" "text" DEFAULT ''::"text" NOT NULL
);

ALTER TABLE "public"."aircraft" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."detection" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "x" smallint,
    "y" smallint,
    "width" smallint,
    "height" smallint,
    "confidence" real,
    "image" "uuid"
);

ALTER TABLE "public"."detection" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."flight" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "flightdate" "uuid",
    "aircraft" "uuid",
    "start" timestamp with time zone,
    "end" timestamp with time zone
);

ALTER TABLE "public"."flight" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."flightdate" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "mission" "uuid",
    "start_date" timestamp with time zone,
    "end_date" timestamp with time zone,
    "aircraft" "uuid"
);

ALTER TABLE "public"."flightdate" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."flightplan" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "checkpoints" "jsonb"[],
    "boundary" "jsonb"[] NOT NULL,
    "location" "jsonb" NOT NULL
);

ALTER TABLE "public"."flightplan" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."image" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "flight" "uuid",
    "rgb_path" "text",
    "thermal_path" "text",
    "location" "jsonb"
);

ALTER TABLE "public"."image" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."mission" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "owner" "uuid",
    "plan" "uuid",
    "description" "text" DEFAULT ''::"text" NOT NULL
);

ALTER TABLE "public"."mission" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."user" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "id" "uuid" NOT NULL
);

ALTER TABLE "public"."user" OWNER TO "postgres";

ALTER TABLE ONLY "public"."aircraft"
    ADD CONSTRAINT "aircraft_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."detection"
    ADD CONSTRAINT "detection_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."flight"
    ADD CONSTRAINT "flight_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."flightdate"
    ADD CONSTRAINT "flightdate_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."flightplan"
    ADD CONSTRAINT "flightplan_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."image"
    ADD CONSTRAINT "image_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."mission"
    ADD CONSTRAINT "mission_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."user"
    ADD CONSTRAINT "user_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."aircraft"
    ADD CONSTRAINT "aircraft_owner_fkey" FOREIGN KEY ("owner") REFERENCES "public"."user"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."detection"
    ADD CONSTRAINT "detection_image_fkey" FOREIGN KEY ("image") REFERENCES "public"."image"("id");

ALTER TABLE ONLY "public"."flight"
    ADD CONSTRAINT "flight_aircraft_fkey" FOREIGN KEY ("aircraft") REFERENCES "public"."aircraft"("id");

ALTER TABLE ONLY "public"."flight"
    ADD CONSTRAINT "flight_flightdate_fkey" FOREIGN KEY ("flightdate") REFERENCES "public"."flightdate"("id");

ALTER TABLE ONLY "public"."flightdate"
    ADD CONSTRAINT "flightdate_aircraft_fkey" FOREIGN KEY ("aircraft") REFERENCES "public"."aircraft"("id");

ALTER TABLE ONLY "public"."flightdate"
    ADD CONSTRAINT "flightdate_mission_fkey" FOREIGN KEY ("mission") REFERENCES "public"."mission"("id");

ALTER TABLE ONLY "public"."image"
    ADD CONSTRAINT "image_flight_fkey" FOREIGN KEY ("flight") REFERENCES "public"."flight"("id");

ALTER TABLE ONLY "public"."mission"
    ADD CONSTRAINT "mission_owner_fkey" FOREIGN KEY ("owner") REFERENCES "public"."user"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."mission"
    ADD CONSTRAINT "mission_plan_fkey" FOREIGN KEY ("plan") REFERENCES "public"."flightplan"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user"
    ADD CONSTRAINT "user_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE SET NULL;

ALTER TABLE "public"."aircraft" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."detection" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."flight" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."flightdate" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."flightplan" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."image" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."mission" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."user" ENABLE ROW LEVEL SECURITY;

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON TABLE "public"."aircraft" TO "anon";
GRANT ALL ON TABLE "public"."aircraft" TO "authenticated";
GRANT ALL ON TABLE "public"."aircraft" TO "service_role";

GRANT ALL ON TABLE "public"."detection" TO "anon";
GRANT ALL ON TABLE "public"."detection" TO "authenticated";
GRANT ALL ON TABLE "public"."detection" TO "service_role";

GRANT ALL ON TABLE "public"."flight" TO "anon";
GRANT ALL ON TABLE "public"."flight" TO "authenticated";
GRANT ALL ON TABLE "public"."flight" TO "service_role";

GRANT ALL ON TABLE "public"."flightdate" TO "anon";
GRANT ALL ON TABLE "public"."flightdate" TO "authenticated";
GRANT ALL ON TABLE "public"."flightdate" TO "service_role";

GRANT ALL ON TABLE "public"."flightplan" TO "anon";
GRANT ALL ON TABLE "public"."flightplan" TO "authenticated";
GRANT ALL ON TABLE "public"."flightplan" TO "service_role";

GRANT ALL ON TABLE "public"."image" TO "anon";
GRANT ALL ON TABLE "public"."image" TO "authenticated";
GRANT ALL ON TABLE "public"."image" TO "service_role";

GRANT ALL ON TABLE "public"."mission" TO "anon";
GRANT ALL ON TABLE "public"."mission" TO "authenticated";
GRANT ALL ON TABLE "public"."mission" TO "service_role";

GRANT ALL ON TABLE "public"."user" TO "anon";
GRANT ALL ON TABLE "public"."user" TO "authenticated";
GRANT ALL ON TABLE "public"."user" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";

RESET ALL;
