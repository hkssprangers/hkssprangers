-- CreateTable
CREATE TABLE "timeSlotRule" (
    "startTime" TIMESTAMPTZ(0) NOT NULL,
    "endTime" TIMESTAMPTZ(0) NOT NULL,
    "availability" JSONB NOT NULL,

    CONSTRAINT "timeSlotRule_pkey" PRIMARY KEY ("startTime","endTime")
);
