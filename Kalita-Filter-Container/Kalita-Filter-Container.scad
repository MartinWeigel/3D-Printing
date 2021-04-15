/**
 * Copyright (C) 2021 Martin Weigel <mail@MartinWeigel.com>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
use <BOSL/shapes.scad>;
$fn = 50;
EPS = 0.001;

rounded_corners = 5;

// Kalita Filter Measurements
kalita_bottom_diameter  = 40;
kalita_top_diameter     = 80;
kalita_height           = 45;
kalita_height_100       = 88;
kalita_vertices         = 20;

// Lid parameters
lid_height              = 10;
lid_handle              = 40;
lid_narrowing           = 20;

// Design parameters
wall            = 2;
hole_diameter   = 20;

module star_cylinder(h, s1, s2) {
    union() {
        for ( i = [1:5]) {
            angle_segment = 360.0 / kalita_vertices;
            angle = i * angle_segment;
            rotate([0, 0, angle]) {
                prismoid(size1=[s1, s1], size2=[s2, s2], h=h);
            }
        }
    }
}

module container_top() {
    // Top cylinder
    translate([0, 0, kalita_height+wall-EPS]) {
        extra_h = kalita_height_100 - kalita_height;
        difference() {
            star_cylinder(extra_h, kalita_top_diameter+wall, kalita_top_diameter+wall);
            star_cylinder(extra_h, kalita_top_diameter, kalita_top_diameter);
        }
    }
}
module container_bottom() {
    difference() {
        star_cylinder(kalita_height+wall, kalita_bottom_diameter+wall, kalita_top_diameter+wall);
        translate([0,0,wall]) {
            star_cylinder(kalita_height, kalita_bottom_diameter, kalita_top_diameter);
        }
        cylinder(kalita_height_100, hole_diameter/2, hole_diameter/2);
    }
}


module container_lid() {
    // Top cylinder
    translate([0, 0, kalita_height_100+wall]) {
        union() {
            difference() {
                star_cylinder(lid_height, kalita_top_diameter+wall, kalita_top_diameter-lid_narrowing);
                // Handle
                translate([0, 0, wall]) {
                    difference() {
                        handle_w = 5;
                        cylinder(lid_height, lid_handle/2, lid_handle/2);
                        translate([-lid_handle/2, -handle_w/2, 0]) {
                            cube([lid_handle, handle_w, lid_height]);
                        }
                    }
                }
            }
        }
        translate([0, 0, -wall]) {
            // Overlap
            difference() {
                wiggle_room = 1;
                size = kalita_top_diameter-wiggle_room;
                star_cylinder(wall, size, size);
                star_cylinder(wall, size-wall, size-wall);
            }
        }
    }
}

union() {
    // Top of kalita filter. Make sure this fits in box.
    //translate([0,0,kalita_height+1])  color("#FF0000") { cylinder(1, 95/2, 95/2); }
    //translate([0,0,kalita_height])    color("#0000FF") { cylinder(1, 110/2, 110/2); }

    // Lid
    color("#0000FF") {
        container_lid();
    }

    // Container
    color("#00FFFF") {
        container_top();
        container_bottom();
    }
    // Bottom of kalita filter. Make sure this fits in box.
    //cylinder(3, 50/2, 50/2);
}