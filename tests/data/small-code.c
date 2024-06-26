/* SCANNER TEST */

/*
 * Copyright © 2016 Collabora, Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice (including the
 * next paragraph) shall be included in all copies or substantial
 * portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <stdbool.h>
#include <stdlib.h>
#include <stdint.h>
#include "wayland-util.h"

extern const struct wl_interface another_intf_interface;
extern const struct wl_interface intf_not_here_interface;

static const struct wl_interface *small_test_types[] = {
	NULL,
	&intf_not_here_interface,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	&another_intf_interface,
};

static const struct wl_message intf_A_requests[] = {
	{ "rq1", "sun", small_test_types + 0 },
	{ "rq2", "nsiufho", small_test_types + 1 },
	{ "destroy", "", small_test_types + 0 },
};

static const struct wl_message intf_A_events[] = {
	{ "hey", "", small_test_types + 0 },
	{ "yo", "2", small_test_types + 0 },
};

WL_EXPORT const struct wl_interface intf_A_interface = {
	"intf_A", 3,
	3, intf_A_requests,
	2, intf_A_events,
};

