package hkssprangers.info;

typedef TimeSlot = {
    start: LocalDateString,
    end: LocalDateString,
}

typedef TimeSlotChoice = TimeSlot & { availability: Availability };
