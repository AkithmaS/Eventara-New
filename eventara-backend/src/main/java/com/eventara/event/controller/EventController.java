package com.eventara.event.controller;

// GET    /api/v1/events                        — public: browse pageable events
// GET    /api/v1/events/{id}                   — public: event detail
// GET    /api/v1/events/search                 — public: search/filter
// POST   /api/v1/organizer/events              — ORGANIZER: create event
// PUT    /api/v1/organizer/events/{id}         — ORGANIZER: update event
// DELETE /api/v1/organizer/events/{id}         — ORGANIZER: delete draft
// POST   /api/v1/organizer/events/{id}/submit  — ORGANIZER: submit for review
// PUT    /api/v1/admin/events/{id}/publish     — ADMIN: publish
// PUT    /api/v1/admin/events/{id}/reject      — ADMIN: reject
// GET    /api/v1/events/{id}/seats             — get seat map for event
