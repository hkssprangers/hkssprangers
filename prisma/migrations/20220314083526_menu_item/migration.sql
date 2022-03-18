-- CreateTable
CREATE TABLE "menuItem" (
    "menuItemId" BIGINT NOT NULL DEFAULT unique_rowid(),
    "creationTime" TIMESTAMPTZ(0) NOT NULL,
    "startTime" TIMESTAMPTZ(0) NOT NULL,
    "endTime" TIMESTAMPTZ(0) NOT NULL,
    "shopId" VARCHAR(50) NOT NULL,
    "items" JSONB NOT NULL,
    "deleted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "menuItem_pkey" PRIMARY KEY ("menuItemId")
);

-- CreateIndex
CREATE INDEX "menuItem_shop_time" ON "menuItem"("shopId", "startTime", "endTime");
