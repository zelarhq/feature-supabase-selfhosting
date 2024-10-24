/*
  Warnings:

  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "User";

-- CreateTable
CREATE TABLE "accounts" (
    "id" UUID NOT NULL,
    "owner" TEXT NOT NULL,
    "creation_time" TIMESTAMPTZ NOT NULL,
    "api_key" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "subscription_created" TIMESTAMPTZ,
    "subscription_ended" TIMESTAMPTZ,
    "subscription_current_period_start" TIMESTAMPTZ,
    "stripe_active_subscription_id" TEXT,
    "billing_state" TEXT,
    "subscription_current_period_end" TIMESTAMPTZ,
    "price" DECIMAL NOT NULL,
    "payment_cycle" TEXT,
    "billing_country" TEXT,
    "currency" TEXT,
    "plan" TEXT,
    "access_count" INTEGER,
    "admin_count" INTEGER,
    "subscription_status" TEXT,
    "access" TEXT[],
    "admins" TEXT[],
    "datacenter_id" UUID NOT NULL,

    CONSTRAINT "accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "activities" (
    "activity_id" SERIAL NOT NULL,
    "user_id" UUID NOT NULL,
    "activity" TEXT NOT NULL,
    "activity_time" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "activities_pkey" PRIMARY KEY ("activity_id")
);

-- CreateTable
CREATE TABLE "cluster_resources" (
    "id" VARCHAR NOT NULL,
    "CPU" SMALLINT NOT NULL,
    "RAM" SMALLINT NOT NULL,
    "SSD" SMALLINT NOT NULL,
    "name" VARCHAR NOT NULL,
    "size" VARCHAR NOT NULL,

    CONSTRAINT "cluster_resources_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "clusters" (
    "uid" UUID NOT NULL,
    "id" BIGINT NOT NULL,
    "account_id" TEXT NOT NULL,
    "created_date" TIMESTAMPTZ NOT NULL,
    "datacenter_id" TEXT NOT NULL,
    "description" TEXT,
    "expiry" TIMESTAMPTZ NOT NULL,
    "features" JSONB NOT NULL,
    "kubeconfig" TEXT NOT NULL,
    "kubeconfig_dlink" TEXT,
    "name" TEXT NOT NULL,
    "owner" TEXT NOT NULL,
    "size" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "version" TEXT NOT NULL,

    CONSTRAINT "clusters_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "datacenters" (
    "uid" UUID NOT NULL,
    "owner" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "sub_domain" TEXT NOT NULL,
    "managed" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "cidr" TEXT NOT NULL,
    "id" BIGINT NOT NULL,
    "apps_subdomain" TEXT NOT NULL,
    "external_ip" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "plans" JSONB NOT NULL,
    "project_url" TEXT NOT NULL,
    "project_key" TEXT NOT NULL,

    CONSTRAINT "datacenters_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "invites" (
    "id" BIGSERIAL NOT NULL,
    "hashed_email" TEXT NOT NULL,
    "owner" TEXT NOT NULL,
    "account" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "time" TIMESTAMPTZ NOT NULL,
    "uid" UUID NOT NULL,

    CONSTRAINT "invites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoices" (
    "id" TEXT NOT NULL,
    "total" DECIMAL NOT NULL,
    "sub_total" DECIMAL NOT NULL,
    "amount_due" DECIMAL NOT NULL,
    "amount_paid" DECIMAL NOT NULL,
    "tax" DECIMAL NOT NULL,
    "currency" TEXT NOT NULL,
    "created" TIMESTAMPTZ NOT NULL,
    "status" TEXT NOT NULL,
    "hosted_invoice_url" TEXT NOT NULL,
    "account_id" UUID NOT NULL,

    CONSTRAINT "invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kubeconfig" (
    "id" UUID NOT NULL,
    "url" TEXT NOT NULL,
    "clustername" TEXT NOT NULL,
    "createdtime" TIMESTAMPTZ NOT NULL,
    "long_url" TEXT NOT NULL,
    "code" TEXT NOT NULL,

    CONSTRAINT "kubeconfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "marketplace" (
    "uid" UUID NOT NULL,
    "values_reference" TEXT NOT NULL,
    "helm_repo_add" TEXT NOT NULL,
    "display_name" TEXT NOT NULL,
    "values" JSONB NOT NULL,
    "id" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "default_enable" BOOLEAN NOT NULL,
    "show_in_marketplace" BOOLEAN NOT NULL,
    "icon" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "know_more" TEXT NOT NULL,
    "namespace" TEXT NOT NULL,
    "default_yaml" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "label_check" JSONB NOT NULL,
    "owned_by" TEXT NOT NULL,
    "customer_addon" BOOLEAN NOT NULL,
    "chart" TEXT NOT NULL,
    "optional_values" JSONB NOT NULL,
    "credential_fields" JSONB NOT NULL,
    "secret_command" TEXT NOT NULL,
    "doc_reference" TEXT NOT NULL,

    CONSTRAINT "marketplace_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "uid" UUID NOT NULL,
    "accepted" BOOLEAN NOT NULL,
    "displayname" VARCHAR NOT NULL,
    "lastlogintime" TIMESTAMPTZ NOT NULL,
    "photourl" TEXT NOT NULL,
    "creationtime" TIMESTAMPTZ NOT NULL,
    "stripe_customer_id" TEXT,
    "slack_keys" JSONB,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_uid_key" ON "users"("uid");

-- AddForeignKey
ALTER TABLE "activities" ADD CONSTRAINT "activities_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("uid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
