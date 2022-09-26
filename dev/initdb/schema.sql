CREATE TABLE public.courier (
	"courierId" INT8 NOT NULL DEFAULT unique_rowid(),
	"courierTgUsername" VARCHAR(128) NOT NULL,
	"courierTgId" VARCHAR(128) NULL,
	"paymeAvailable" BOOL NOT NULL,
	"fpsAvailable" BOOL NOT NULL,
	deleted BOOL NOT NULL DEFAULT false,
	"isAdmin" BOOL NOT NULL DEFAULT false,
	CONSTRAINT courier_pkey PRIMARY KEY ("courierId" ASC),
	UNIQUE INDEX "courier_UN_tgUsername" ("courierTgUsername" ASC),
	UNIQUE INDEX "courier_UN_tgId" ("courierTgId" ASC)
);
CREATE TABLE public.delivery (
	"deliveryId" INT8 NOT NULL DEFAULT unique_rowid(),
	"creationTime" TIMESTAMPTZ(0) NOT NULL,
	"deliveryCode" VARCHAR(50) NULL,
	"pickupLocation" VARCHAR(1024) NOT NULL,
	"deliveryFee" DECIMAL(12,4) NULL,
	"pickupTimeSlotStart" TIMESTAMPTZ(0) NOT NULL,
	"pickupTimeSlotEnd" TIMESTAMPTZ(0) NOT NULL,
	"pickupMethod" VARCHAR(64) NOT NULL,
	"paymeAvailable" BOOL NOT NULL,
	"fpsAvailable" BOOL NOT NULL,
	"customerTgUsername" VARCHAR(128) NULL,
	"customerTgId" VARCHAR(128) NULL,
	"customerTel" VARCHAR(64) NULL,
	"customerWhatsApp" VARCHAR(64) NULL,
	"customerSignal" VARCHAR(64) NULL,
	"customerPreferredContactMethod" VARCHAR(64) NULL,
	"customerBackupContactMethod" VARCHAR(64) NULL,
	"customerNote" VARCHAR(2048) NULL,
	deleted BOOL NOT NULL DEFAULT false,
	CONSTRAINT delivery_pkey PRIMARY KEY ("deliveryId" ASC),
	INDEX "delivery_pickupTimeSlotStart" ("pickupTimeSlotStart" ASC)
);
CREATE TABLE public."deliveryCourier" (
	"deliveryId" INT8 NOT NULL,
	"courierId" INT8 NOT NULL,
	"deliveryFee" DECIMAL(12,4) NOT NULL,
	"deliverySubsidy" DECIMAL(12,4) NOT NULL,
	deleted BOOL NOT NULL DEFAULT false,
	CONSTRAINT "deliveryCourier_pkey" PRIMARY KEY ("deliveryId" ASC, "courierId" ASC),
	INDEX "deliveryCourier_FK_courier" ("courierId" ASC)
);
CREATE TABLE public."deliveryOrder" (
	"deliveryId" INT8 NOT NULL,
	"orderId" INT8 NOT NULL,
	deleted BOOL NOT NULL DEFAULT false,
	CONSTRAINT "deliveryOrder_pkey" PRIMARY KEY ("deliveryId" ASC, "orderId" ASC),
	INDEX "deliveryOrder_FK_order" ("orderId" ASC)
);
CREATE TABLE public."googleFormImport" (
	"importTime" TIMESTAMPTZ(0) NOT NULL,
	"spreadsheetId" VARCHAR(100) NOT NULL,
	"lastRow" INT4 NOT NULL,
	CONSTRAINT "googleFormImport_pkey" PRIMARY KEY ("importTime" ASC, "spreadsheetId" ASC)
);
CREATE TABLE public."order" (
	"orderId" INT8 NOT NULL DEFAULT unique_rowid(),
	"creationTime" TIMESTAMPTZ(0) NOT NULL,
	"orderCode" VARCHAR(50) NULL,
	"shopId" VARCHAR(50) NOT NULL,
	"orderDetails" VARCHAR(2048) NOT NULL,
	"orderPrice" DECIMAL(12,4) NOT NULL,
	"platformServiceCharge" DECIMAL(12,4) NOT NULL,
	"wantTableware" BOOL NOT NULL,
	"customerNote" VARCHAR(2048) NULL,
	deleted BOOL NOT NULL DEFAULT false,
	CONSTRAINT order_pkey PRIMARY KEY ("orderId" ASC)
);
CREATE TABLE public.receipt (
	"receiptId" INT8 NOT NULL DEFAULT unique_rowid(),
	"receiptUrl" VARCHAR(1024) NOT NULL,
	"orderId" INT8 NULL,
	"uploaderCourierId" INT8 NULL,
	CONSTRAINT receipt_pkey PRIMARY KEY ("receiptId" ASC),
	INDEX "receipt_courier_FK" ("uploaderCourierId" ASC),
	INDEX "receipt_order_FK" ("orderId" ASC)
);
CREATE TABLE public."tgMessage" (
	"tgMessageId" INT8 NOT NULL DEFAULT unique_rowid(),
	"receiverId" VARCHAR(128) NOT NULL,
	"messageData" JSONB NULL,
	"updateType" VARCHAR(50) NULL,
	"updateData" JSONB NULL,
	CONSTRAINT "tgMessage_pkey" PRIMARY KEY ("tgMessageId" ASC),
	INDEX "receiverId" ("receiverId" ASC)
);
CREATE TABLE public."tgPrivateChat" (
	"botId" VARCHAR(128) NOT NULL,
	"userId" VARCHAR(128) NOT NULL,
	"userUsername" VARCHAR(128) NULL,
	"chatId" VARCHAR(128) NULL,
	"lastUpdateData" JSONB NULL,
	CONSTRAINT "tgPrivateChat_pkey" PRIMARY KEY ("botId" ASC, "userId" ASC)
);
CREATE TABLE public."twilioMessage" (
	"twilioMessageId" INT8 NOT NULL DEFAULT unique_rowid(),
	"creationTime" TIMESTAMPTZ(0) NOT NULL,
	data JSONB NOT NULL,
	CONSTRAINT "twilioMessage_pkey" PRIMARY KEY ("twilioMessageId" ASC)
);
CREATE TABLE public._prisma_migrations (
	id VARCHAR(36) NOT NULL,
	checksum VARCHAR(64) NOT NULL,
	finished_at TIMESTAMPTZ NULL,
	migration_name VARCHAR(255) NOT NULL,
	logs STRING NULL,
	rolled_back_at TIMESTAMPTZ NULL,
	started_at TIMESTAMPTZ NOT NULL DEFAULT now():::TIMESTAMPTZ,
	applied_steps_count INT4 NOT NULL DEFAULT 0:::INT8,
	CONSTRAINT "primary" PRIMARY KEY (id ASC)
);
CREATE TABLE public."menuItem" (
	"menuItemId" INT8 NOT NULL DEFAULT unique_rowid(),
	"creationTime" TIMESTAMPTZ(0) NOT NULL,
	"startTime" TIMESTAMPTZ(0) NOT NULL,
	"endTime" TIMESTAMPTZ(0) NOT NULL,
	"shopId" VARCHAR(50) NOT NULL,
	items JSONB NOT NULL,
	deleted BOOL NOT NULL DEFAULT false,
	CONSTRAINT "menuItem_pkey" PRIMARY KEY ("menuItemId" ASC),
	INDEX "menuItem_shop_time" ("shopId" ASC, "startTime" ASC, "endTime" ASC)
);
CREATE TABLE public."timeSlotRule" (
	"startTime" TIMESTAMPTZ(0) NOT NULL,
	"endTime" TIMESTAMPTZ(0) NOT NULL,
	availability JSONB NOT NULL,
	CONSTRAINT "timeSlotRule_pkey" PRIMARY KEY ("startTime" ASC, "endTime" ASC)
);
