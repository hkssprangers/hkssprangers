-- CreateTable
CREATE TABLE "courier" (
    "courierId" BIGINT NOT NULL DEFAULT unique_rowid(),
    "courierTgUsername" VARCHAR(128) NOT NULL,
    "courierTgId" VARCHAR(128),
    "paymeAvailable" BOOLEAN NOT NULL,
    "fpsAvailable" BOOLEAN NOT NULL,
    "deleted" BOOLEAN NOT NULL DEFAULT false,
    "isAdmin" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "courier_pkey" PRIMARY KEY ("courierId")
);

-- CreateTable
CREATE TABLE "delivery" (
    "deliveryId" BIGINT NOT NULL DEFAULT unique_rowid(),
    "creationTime" TIMESTAMPTZ(0) NOT NULL,
    "deliveryCode" VARCHAR(50),
    "pickupLocation" VARCHAR(1024) NOT NULL,
    "deliveryFee" DECIMAL(12,4),
    "pickupTimeSlotStart" TIMESTAMPTZ(0) NOT NULL,
    "pickupTimeSlotEnd" TIMESTAMPTZ(0) NOT NULL,
    "pickupMethod" VARCHAR(64) NOT NULL,
    "paymeAvailable" BOOLEAN NOT NULL,
    "fpsAvailable" BOOLEAN NOT NULL,
    "customerTgUsername" VARCHAR(128),
    "customerTgId" VARCHAR(128),
    "customerTel" VARCHAR(64),
    "customerWhatsApp" VARCHAR(64),
    "customerSignal" VARCHAR(64),
    "customerPreferredContactMethod" VARCHAR(64),
    "customerBackupContactMethod" VARCHAR(64),
    "customerNote" VARCHAR(2048),
    "deleted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "delivery_pkey" PRIMARY KEY ("deliveryId")
);

-- CreateTable
CREATE TABLE "deliveryCourier" (
    "deliveryId" BIGINT NOT NULL,
    "courierId" BIGINT NOT NULL,
    "deliveryFee" DECIMAL(12,4) NOT NULL,
    "deliverySubsidy" DECIMAL(12,4) NOT NULL,
    "deleted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "deliveryCourier_pkey" PRIMARY KEY ("deliveryId","courierId")
);

-- CreateTable
CREATE TABLE "deliveryOrder" (
    "deliveryId" BIGINT NOT NULL,
    "orderId" BIGINT NOT NULL,
    "deleted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "deliveryOrder_pkey" PRIMARY KEY ("deliveryId","orderId")
);

-- CreateTable
CREATE TABLE "flyway_schema_history" (
    "installed_rank" INTEGER NOT NULL,
    "version" VARCHAR(50),
    "description" VARCHAR(200) NOT NULL,
    "type" VARCHAR(20) NOT NULL,
    "script" VARCHAR(1000) NOT NULL,
    "checksum" INTEGER,
    "installed_by" VARCHAR(100) NOT NULL,
    "installed_on" TIMESTAMPTZ(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "execution_time" INTEGER NOT NULL,
    "success" BOOLEAN NOT NULL,

    CONSTRAINT "flyway_schema_history_pkey" PRIMARY KEY ("installed_rank")
);

-- CreateTable
CREATE TABLE "googleFormImport" (
    "importTime" TIMESTAMPTZ(0) NOT NULL,
    "spreadsheetId" VARCHAR(100) NOT NULL,
    "lastRow" INTEGER NOT NULL,

    CONSTRAINT "googleFormImport_pkey" PRIMARY KEY ("importTime","spreadsheetId")
);

-- CreateTable
CREATE TABLE "order" (
    "orderId" BIGINT NOT NULL DEFAULT unique_rowid(),
    "creationTime" TIMESTAMPTZ(0) NOT NULL,
    "orderCode" VARCHAR(50),
    "shopId" VARCHAR(50) NOT NULL,
    "orderDetails" VARCHAR(2048) NOT NULL,
    "orderPrice" DECIMAL(12,4) NOT NULL,
    "platformServiceCharge" DECIMAL(12,4) NOT NULL,
    "wantTableware" BOOLEAN NOT NULL,
    "customerNote" VARCHAR(2048),
    "deleted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "order_pkey" PRIMARY KEY ("orderId")
);

-- CreateTable
CREATE TABLE "receipt" (
    "receiptId" BIGINT NOT NULL DEFAULT unique_rowid(),
    "receiptUrl" VARCHAR(1024) NOT NULL,
    "orderId" BIGINT,
    "uploaderCourierId" BIGINT,

    CONSTRAINT "receipt_pkey" PRIMARY KEY ("receiptId")
);

-- CreateTable
CREATE TABLE "tgMessage" (
    "tgMessageId" BIGINT NOT NULL DEFAULT unique_rowid(),
    "receiverId" VARCHAR(128) NOT NULL,
    "messageData" JSONB,
    "updateType" VARCHAR(50),
    "updateData" JSONB,

    CONSTRAINT "tgMessage_pkey" PRIMARY KEY ("tgMessageId")
);

-- CreateTable
CREATE TABLE "twilioMessage" (
    "twilioMessageId" BIGINT NOT NULL DEFAULT unique_rowid(),
    "creationTime" TIMESTAMPTZ(0) NOT NULL,
    "data" JSONB NOT NULL,

    CONSTRAINT "twilioMessage_pkey" PRIMARY KEY ("twilioMessageId")
);

-- CreateIndex
CREATE UNIQUE INDEX "courier_UN_tgUsername" ON "courier"("courierTgUsername");

-- CreateIndex
CREATE UNIQUE INDEX "courier_UN_tgId" ON "courier"("courierTgId");

-- CreateIndex
CREATE INDEX "deliveryCourier_FK_courier" ON "deliveryCourier"("courierId");

-- CreateIndex
CREATE INDEX "deliveryOrder_FK_order" ON "deliveryOrder"("orderId");

-- CreateIndex
CREATE INDEX "flyway_schema_history_s_idx" ON "flyway_schema_history"("success");

-- CreateIndex
CREATE INDEX "receipt_courier_FK" ON "receipt"("uploaderCourierId");

-- CreateIndex
CREATE INDEX "receipt_order_FK" ON "receipt"("orderId");

-- CreateIndex
CREATE INDEX "receiverId" ON "tgMessage"("receiverId");
