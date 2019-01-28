globals
[
  tick-delta                     ; determines how much we advance the tick counter
  
  ;; setup variables
  particle-size                  ; size of particles
  biker-size                     ; size of bikers
  max-speed                      ; maximum particle speed
  total-particle-number          ; total number of particles
  current-biker-speed            ; the current speed of bikers
  current-biker-number           ; the current number of bikers
  
  ;; setup booleans
  world-created?                 ; specifies if the world was created
  bikers-placed?                 ; specifies if bikers are placed in the world
  particles-placed?              ; specifies if particles are placed in the world
  
  ;; reporter variables
  biker-total-collisions         ; total biker collisions
  biker-x-collisions             ; followed biker's collisions
  biker-x-collisions-percentage  ; followed biker's collision percentage
  particle-avg-speed             ; particle average speed
  
  ;; constants
  gravity                        ; gravity constant
  
  ;; internal movement variables
  next-rotation-order            ; next rotation internal movement order
  next-arrowhead-order           ; next arrowhead internal movement order
  next-line-1-order              ; next line 1 internal movement order
  next-line-2-order              ; next line 2 internal movement order
  selected-line                  ; selected line formation
  arrowhead-leader               ; current arrowhead leader
  arrowhead-direction            ; current arrowhead leadership direction
  line-1-leader                  ; current line 1 leader
  line-2-leader                  ; current line 2 leader
  moving-bikers                  ; number of bikers moving between positions
  movement-timer                 ; time (in ticks) since the last biker movement
  bikers-collided?               ; specifies if bikers have collided
]


breed [bikers biker]
bikers-own
[
  speed
  mass
  pulse
  
  collision-history
  collisions-over-time
  last-collisions-over-time
  collisions-per-biker
  
  movement-order 
  movement-type
  destination
]


breed [particles particle]
particles-own
[
  speed
  mass
]


breed [flashes flash]


;;;;;;;;;;;;;;;;;;;
;; SETUP PROCEDURES
;;;;;;;;;;;;;;;;;;;


to setup-world
  ;; initialize the world and default globals
  
  clear-all
  ask patches [ setup-road ]
  set tick-delta 1
  set gravity 9.81
  set world-created? true
  reset-ticks
end


to setup-bikers
  ;; place bikers in the world
  ;; while active, allows bikers to be moved by clicking and dragging
  
  ;; display a message if the world was not created
  if (world-created? != true)
  [
    user-message "Before setting up bikers, create a world using 'Setup World'."
    stop
  ]
  
  ;; reset biker movement if bikers have collided
  if (bikers-collided? = true) [ reset-moving-bikers ]
  
  ;; place bikers in the world and initialize default globals
  if (bikers-placed? != true)
  [
    set-default-shape bikers "circle"
    set biker-size 6
    set current-biker-speed biker-speed
    set current-biker-number number-of-bikers
    set next-rotation-order 0
    set next-arrowhead-order 0
    set next-line-1-order 0
    set next-line-2-order 0
    set moving-bikers 0
    set movement-timer 1000
    make-bikers
    do-histogram-bikers-mass
    set bikers-placed? true
  ]
  
  ;; when the mouse button is held down allow to drag-move the selected biker
  if mouse-down?
  [
    let candidate (min-one-of bikers [distancexy mouse-xcor mouse-ycor])
    if ([distancexy mouse-xcor mouse-ycor] of candidate) < (biker-size / 2)
    [
      ;; the WATCH primitive puts a "halo" around the watched turtle
      watch candidate
      while [ mouse-down? ]
      [
        ;; if we don't force the display to update, the user won't
        ;; be able to see the turtle moving around
        display
        ;; the SUBJECT primitive reports the turtle being watched
        ask subject [ setxy mouse-xcor mouse-ycor ]
      ]
      ;; undoes the effects of WATCH
      reset-perspective
    ]
  ]
  
  display
end


to setup-particles
  ;; populate the world with particles at random positions
  
  ;; display a message if the world was not created and populated with bikers
  if (world-created? != true) or (bikers-placed? != true)
  [
    user-message (word "Before setting up particles, create a world and populate it with bikers "
                       "using 'Setup World' and 'Setup Bikers'.")
    stop
  ]
  
  set-default-shape particles "circle"
  set particle-size 0.5
  set total-particle-number (total-particle-number + number-of-particles)
  make-particles
  set particles-placed? true
  display
end


to setup-road
  ;; patch procedure
  ;; colour patches to paint a horizontal road
  
  let bound (max-pycor / 5)
  ifelse (pycor < (max-pycor  - bound)) and (pycor > (min-pycor + bound))
  [ set pcolor red - 3 ]
  [ set pcolor green - 1 ]
end


to make-bikers
  ;; create new bikers and set their default properties
  
  create-bikers number-of-bikers
  [
    set color orange
    set size biker-size
    set label (who + 1)
    
    setxy 0 0
    set heading 90
    set speed current-biker-speed
    set mass (100 * 1000000)  ;; multiply mass by 1,000,000 to create a large variance
                              ;; between biker mass and particle mass
    set pulse 0
    
    set collision-history [0 0 0 0 0]
    set collisions-over-time 0
    set last-collisions-over-time 0
    set collisions-per-biker 0

    ;; no internal movement by default
    set movement-order -1
    set movement-type ""
    set destination []
  ] 
end


to make-particles
  ;; create new particles and set their default properties
  
  create-particles total-particle-number
  [
    set speed particle-initial-speed
    set size particle-size
    set mass (size * size)  ;; set the mass proportional to the area of the particle
    set color white
    random-position
  ]
end


to mark-collision [x y]
  ;; create an x symbol at the specified location
  
  hatch-flashes 1
  [
    set shape "x"
    set color red
    set size 5
    set label ""
    setxy x y
  ]
end


to apply-mass
  ;; set a biker's mass to a new value
  
  ;; display a message if bikers were not placed in the world
  if (bikers-placed? != true)
  [
    user-message (word "There are no bikers in the world. Create a world and populate "
                       "it with bikers using 'Setup World' and 'Setup Bikers'.")
    stop
  ]
  
  ask biker (biker-number - 1) [ set mass biker-mass * 1000000 ]  ;; multiply mass by 1,000,000 to create a large variance
                                                                  ;; between biker mass and particle mass
  do-histogram-bikers-mass
end


to random-position
  ;; particle procedure
  ;; set a particle to a random position which does not result in an intersection with another particle or biker
  
  let count-loops 0
  let particle-radius (particle-size / 2)
  let biker-radius (biker-size / 2)
  let both-radii (particle-radius + biker-radius)
  
  while [((count turtles in-radius both-radii) > 1)  and (count-loops < 10000)]
  [
    setxy ((particle-radius - (max-pxcor - particle-size )) + random-float ((2 * (max-pxcor - particle-size )) - (2 * particle-radius)))
          ((particle-radius - (max-pycor - particle-size )) + random-float ((2 * (max-pycor - particle-size )) - (2 * particle-radius)))
    set count-loops count-loops + 1
  ]
end


to select-rotating-bikers
  ;; while active, allows bikers to be selected for rotation internal movement
  ;; in the order in which they were selected (coloured light to dark)
  
  if mouse-down?
  [
    let candidate (min-one-of bikers [distancexy mouse-xcor mouse-ycor])
    
    ;; candidates can only be selected if they are not part of another internal movement tactic
    if (candidate != nobody)
    and (([distancexy mouse-xcor mouse-ycor] of candidate) < (biker-size / 2))
    and ([movement-type] of candidate = "")
    [
      ;; set the selected biker's properties in the rotation formation
      ask candidate
      [
        set movement-order next-rotation-order
        set next-rotation-order (next-rotation-order + 1)
        set movement-type "rotation"
        set color (109 - movement-order)
      ]
      
      ;; interrupt current rotation movement
      ask bikers with [ movement-type = "rotation" ]
      [
        ;; interrupt and reset rotation internal movement
        if (destination != []) [ set moving-bikers (moving-bikers - 1) ]
        set destination []
        set speed current-biker-speed
        set heading 90
      ]
    ]
  ]
  
  display
end


to select-arrowhead-bikers
  ;; while active, allows bikers to be selected for arrowhead internal movement
  
  if mouse-down?
  [
    let candidate (min-one-of bikers [distancexy mouse-xcor mouse-ycor])
    
    ;; candidates can only be selected if they are not part of another internal movement tactic
    ;; and only up to four bikers can be part of the arrowhead formation
    if (candidate != nobody)
    and (([distancexy mouse-xcor mouse-ycor] of candidate) < (biker-size / 2))
    and (next-arrowhead-order < 4)
    and ([movement-type] of candidate = "")
    [
      ;; set the selected biker's properties in the arrowhead formation
      ask candidate
      [
        set movement-order next-arrowhead-order
        set next-arrowhead-order (next-arrowhead-order + 1)
        set movement-type "arrowhead"
        set color violet
      ]
      
      ;; reposition bikers in the arrowhead formation
      ask bikers with [ movement-type = "arrowhead" ]
      [
        ;; interrupt and reset arrowhead internal movement
        if (destination != []) [ set moving-bikers (moving-bikers - 1) ]
        set destination []
        set speed current-biker-speed
        set heading 90
        
        ;; position arrowhead bikers diagonally in equal distances centered around the y-axis
        let top-position ((next-arrowhead-order - 1) * max-pycor * 0.2)
        set ycor (top-position - max-pycor * 0.4 * movement-order)
        set xcor (max-pxcor - (max-pxcor / 2)) - (10 * movement-order)
      ]
      
      ;; set the leader to the first biker in formation order
      set arrowhead-leader 0
      ;; set the leadership order to ascending
      set arrowhead-direction 1
    ]
  ]
  
  display
end


to select-line-bikers
  ;; while active, allows bikers to be selected for line internal movement
  
  if mouse-down?
  [
    let candidate (min-one-of bikers [distancexy mouse-xcor mouse-ycor])
    
    ;; candidates can only be selected if they are not part of another internal movement tactic
    if (candidate != nobody)
    and (([distancexy mouse-xcor mouse-ycor] of candidate) < (biker-size / 2))
    and ([movement-type] of candidate = "")
    [
      ;; set the selected biker's properties in the selected line formation
      ask candidate
      [
        ifelse (selected-line = 0)
        [
          set movement-order next-line-1-order
          set next-line-1-order (next-line-1-order + 1)
          set movement-type "line_1"
        ]
        [
          set movement-order next-line-2-order
          set next-line-2-order (next-line-2-order + 1)
          set movement-type "line_2"
        ]
        set color (87 - 4 * selected-line)
      ]
      
      ;; reposition bikers in both line formations
      ask bikers with [ (movement-type = "line_1") or (movement-type = "line_2") ]
      [
        ;; interrupt and reset internal movement
        if (destination != []) [ set moving-bikers (moving-bikers - 1) ]
        set destination []
        set speed current-biker-speed
        set heading 90
        
        ;; position bikers at equal distances in formation order
        ;; if there is only one line, that line is positioned at the center of the road
        ;; if there are two lines, the lines are positioned near top and bottom of the road
        ifelse any? bikers with [ movement-type = (word "line_" (((selected-line + 1) mod 2) + 1)) ]
        [
          if (movement-type = "line_1") [ set ycor (max-pycor / 2) ]
          if (movement-type = "line_2") [ set ycor (min-pycor / 2) ]
        ]
        [
          set ycor 0
        ]
        set xcor (- 12 * movement-order)
      ]
      
      ;; set both line leaders to the first biker in formation order
      set line-1-leader 0
      set line-2-leader 0
    ]
  ]
  
  display
end


to reset-moving-bikers
  ;; reset biker internal movement
  
  ;; ask bikers to return to their default movement
  ask bikers
  [
    set movement-order -1
    set movement-type ""
    set destination []
    set speed biker-speed
    set heading 90
    set color orange
  ]
  
  ;; destroy all collision markers
  ask flashes [ die ]
  
  ;; reset global variables for internal movement
  set next-rotation-order 0
  set next-arrowhead-order 0
  set next-line-1-order 0
  set next-line-2-order 0
  set moving-bikers 0
  set movement-timer 1000
  set bikers-collided? false
  
  display
end


;;;;;;;;;;
;; GO LOOP
;;;;;;;;;;


to go
  ;; move the simulation one step forward
  
  ;;;;;;;;;;;;;;;;;;;;;;;;
  ;; test for dependencies
  ;;;;;;;;;;;;;;;;;;;;;;;;
  
  ;; display a message if the world was not created and populated with particles and bikers
  
  if (world-created? != true) or (bikers-placed? != true) or (particles-placed? != true)
  [
    user-message (word "Before running the simulation, create a world and populate it with bikers "
                       "and particles using 'Setup World', 'Setup Bikers' and 'Setup Particles'.")
    stop
  ]
  
  ;; display a message if there are not enough bikers in any internal movement formation
  
  let rotation-count (count bikers with [ movement-type = "rotation" ])
  let arrowhead-count (count bikers with [ movement-type = "arrowhead" ])
  let line-1-count (count bikers with [ movement-type = "line_1" ])
  let line-2-count (count bikers with [ movement-type = "line_2" ])
  
  ;; rotation requires at least three bikers
  if (rotation-count > 0) and (rotation-count < 3)
  [
    user-message (word "The Rotation formation requires at least 3 participating bikers.")
    stop
  ]
  
  ;; arrowhead requires at least two bikers
  if (arrowhead-count > 0) and (arrowhead-count < 2)
  [
    user-message (word "The Arrowhead formation requires at least 2 participating bikers.")
    stop
  ]
  
  ;; lines require at least two bikers
  if (line-1-count > 0) and (line-1-count < 2)
  or (line-2-count > 0) and (line-2-count < 2)
  [
    user-message (word "The Line formation requires at least 2 participating bikers.")
    stop
  ]
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; move and collide particles and bikers
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ;; update the tick advance rate based on maximum turtle speed
  set tick-delta (1 / max [speed] of (turtle-set bikers particles))
  
  ;; stop the simulation if bikers have collided
  if (bikers-collided? = true) [ stop ]
  
  ;; order bikers to change positions if the movement interval has passed
  if (movement-timer >= movement-interval) and (moving-bikers = 0) and (any? bikers with [ movement-type != "" ])
  [
    set movement-timer 0
    change-rotation-position
    change-arrowhead-position
    change-line-position
  ]
  
  ;; advance the internal movement timer if all bikers have finished their last internal movement
  if (moving-bikers = 0) [ set movement-timer (movement-timer + tick-delta) ]
  
  ;; move and collide bikers
  ask bikers [ move-biker ]
  ask bikers [ check-for-biker-collision ]
  
  ;; move and collide particles
  ask particles [ move-particle ]
  ask particles [ check-for-particle-collision ]
  
  ;; advance the tick counter and update the display
  tick-advance tick-delta
  display
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; update plots and monitors
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ;; every 3 ticks update the bikers' collision history
  if ((ceiling(ticks) mod 3) = 0) and ((ceiling(ticks) mod 3) != (ceiling(ticks + tick-delta) mod 3))
  [ ask bikers [ calculate-collision-history ] ]
  
  ;; every 1 tick update plots and monitors
  if ((ceiling ticks) < (ceiling (ticks + tick-delta)))
  [
    calculate-pulse
    do-plot-collisions-over-time
    do-plot-bikers-pulse
    do-histogram-collisions-per-biker
    report-particle-avg-speed
    ask bikers [ set collisions-per-biker 0 ]
  ]
  
  ;; if set to follow a biker, mark the specified biker and report its collisions
  ;; otherwise, reset the perspective and collision reports
  ifelse follow-biker?
  [
    watch biker (followed-biker - 1)
    report-biker-x-collisions
  ]
  [
    reset-perspective
    set biker-x-collisions 0
    set biker-x-collisions-percentage 0
  ]
end


;;;;;;;;;;;;;;;;;;;;;
;; PLOTS AND MONITORS
;;;;;;;;;;;;;;;;;;;;;


to calculate-collision-history
  ;; biker procedure
  ;; update a biker's collision history
  
  let collisions-update (collisions-over-time - last-collisions-over-time)
  
  if (collisions-update != 0)
  [ set collision-history lput collisions-update (but-first collision-history) ]
  
  set last-collisions-over-time collisions-over-time
end


to do-plot-collisions-over-time
  ;; draw a plot of the bikers' collisions over time
  
  set-current-plot "Collisions Over Time"
  ask bikers
  [
    set-current-plot-pen (word "biker " label)
    plot (sum collision-history)
  ]
end


to do-plot-bikers-pulse
  ;; draw a plot of the bikers' pulse over time
  
  set-current-plot "Biker Pulse"
  ask bikers
  [
    set-current-plot-pen (word "biker " label)
    plot pulse
  ]
  
  set-current-plot-pen "average"
  plot (mean [pulse] of bikers)
end


to do-histogram-collisions-per-biker
  ;; draw a histogram of recent collisions per biker
  
  set-current-plot "Collisions Per Biker"
  clear-plot
  set-plot-x-range 0 8
  ask bikers
  [
    set-current-plot-pen (word "biker " label)
    plotxy (label - 1) collisions-per-biker
  ]
end


to do-histogram-bikers-mass
  ;; draw a histogram of the bikers' mass
  
  set-current-plot "Biker Mass"
  clear-plot
  set-plot-x-range 0 8
  set-plot-y-range 50 160
  ask bikers
  [
    set-current-plot-pen (word "biker " label)
    plotxy (label - 1) (mass / 1000000)
  ]
end


to report-biker-x-collisions
  ;; report the followed biker's collision number and percentage
  
  ask biker (followed-biker - 1)
  [
    set biker-x-collisions collisions-over-time
    ifelse (biker-total-collisions != 0)
    [ set biker-x-collisions-percentage ((biker-x-collisions / biker-total-collisions) * 100) ]
    [ set biker-x-collisions-percentage 0 ]
  ]
end


to report-particle-avg-speed
  ;; report the particles' average speed
  
  let particle-sum-speed (sum [speed] of particles)
  ifelse (total-particle-number = 0)
  [ set particle-avg-speed 0 ]
  [ set particle-avg-speed (particle-sum-speed / total-particle-number) ]
end


to-report arctan [x]
  ;; approximate the arctangent value of x
  
  report (asin (x / sqrt(1 + x * x)))
end


to calculate-pulse
  ;; biker procedure
  ;; calculate a biker's pulse as a function of mass, ground slope, ground friction and collision rate
  
  ;; pulse is calculated according to the following formula:
  ;;
  ;;   pulse = c1 * m * g * cos(atan(a)) + c2 * m * g * sin(atan(a)) + c3 * p
  ;;
  ;;   m - biker mass
  ;;   g - gravity constant = 9.81 m/s^2
  ;;   a - ground slope in grade percentage
  ;;   p - biker particle collision rate
  ;;   c1 - friction coefficient
  ;;   c2 - slope coefficient
  ;;   c3 - collision coefficient
  
  let arctan-slope (arctan (100 * tan(ground-slope)))
  
  ask bikers
  [
    let corrected-mass (mass / 1000000)
    let number-of-collisions (sum collision-history)
    
    let friction-factor (friction-coefficient * corrected-mass * gravity * (cos arctan-slope))
    let slope-factor (slope-coefficient * corrected-mass * gravity * (sin arctan-slope))
    let collision-factor (collision-coefficient * number-of-collisions)
    
    set pulse (friction-factor + slope-factor + collision-factor)
  ]
end


;;;;;;;;;;;;;;;;;;;;
;; PARTICLE MOVEMENT
;;;;;;;;;;;;;;;;;;;;


to move-particle
  ;; particle procedure
  ;; move a particle forward in respect to its heading and wind influence
  
  ;; calculate the wind strength in each axis
  let wind-strength-x (wind-strength * (sin wind-angle))
  let wind-strength-y (wind-strength * (cos wind-angle))
  
  ;; calculate the new particle position
  let new-x (xcor + sin heading * speed * tick-delta) + wind-strength-x * (0.5 * (tick-delta ^ 2))
  let new-y (ycor + cos heading * speed * tick-delta) + wind-strength-y * (0.5 * (tick-delta ^ 2))
  
  ;; if the particle is moving past a world edge, place the particle at a random position at the opposite edge
  if new-x >= max-pxcor
  [ set new-x (min-pxcor + (size / 2)) set new-y random-pycor set heading (random 180) ]
  if new-x <= min-pxcor
  [ set new-x (max-pxcor - (size / 2)) set new-y random-pycor set heading (180 + (random 180)) ]
  if new-y >= max-pycor
  [ set new-x random-pxcor set new-y (min-pycor + (size / 2)) set heading (270 + (random 180)) ]
  if new-y <= min-pycor
  [ set new-x random-pxcor set new-y (max-pycor - (size / 2)) set heading (90 + (random 180)) ]
  
  ;; set the particle to its new coordinates
  setxy new-x new-y
  ;; factor wind influnece on the particle's heading and speed
  if (wind-strength-x != 0) or (wind-strength-y != 0) [ factor-wind wind-strength-x wind-strength-y ]
end


to factor-wind [ wind-strength-x wind-strength-y ]
  ;; particle procedure
  ;; factor wind influnece on a particle's heading and speed
  
  let vx (sin heading * speed) + (wind-strength-x * tick-delta)
  let vy (cos heading * speed) + (wind-strength-y * tick-delta)
  
  set speed sqrt ((vy ^ 2) + (vx ^ 2))
  set heading atan vx vy
  
  if (speed > (10 + wind-strength)) [ set speed (10 + wind-strength) ]
end


to check-for-particle-collision
  ;; particle procedure
  ;; check for and resolve collisions between a particle and a particle/biker
  
  ;; collision occurs when the summed radii of both candidates exceeds their distance
  let my-radius (size / 2)
  let my-who who
  let biker-radius (biker-size / 2)
  let particle-radius (particle-size / 2)
  let candidate one-of bikers in-radius (my-radius + biker-radius)
  if (candidate = nobody) [ set candidate one-of particles in-radius (my-radius + particle-radius) with [ who < my-who ] ]
  
  ;; resolve the collision
  ;; candidates only collide if one candidate has non-zero speed
  if (candidate != nobody) and ((speed > 0) or ([speed] of candidate > 0))
  [ resolve-particle-collision candidate ]
end


to resolve-particle-collision [ other-turtle ]
  ;; particle procedure
  ;; resolve a collision between a particle and a particle or biker
  
  if is-biker? other-turtle
  [
    set biker-total-collisions (biker-total-collisions + 1)
    ask other-turtle
    [
      set collisions-over-time (collisions-over-time + 1)
      set collisions-per-biker (collisions-per-biker + 1)
    ]
  ]
  
  collide-with other-turtle
end


to collide-with [ other-turtle ]
  ;; turtle procedure
  ;; collide with another particle or biker, changing the speed and heading of both participants
  
  ;; local copies of other-turtle's relevant quantities:
  ;; mass2 speed2 heading2
  ;;
  ;; quantities used in the collision itself:
  ;; theta    ; heading of vector from my center to the center of other-turtle.
  ;; v1t      ; velocity of self along direction theta
  ;; v1l      ; velocity of self perpendicular to theta
  ;; v2t v2l  ; velocity of other-turtle, represented in the same way
  ;; vcm      ; velocity of the center of mass of the colliding particles,
              ;   along direction theta
             
  ;; for convenience, grab some quantities from other-turtle
  let mass2 [mass] of other-turtle
  let speed2 [speed] of other-turtle
  let heading2 [heading] of other-turtle
             
  ;;; phase 0: push/pull apart intersecting turtles
  
  ;; push or pull each particle a distance proportional to their mass so that they
  ;; no longer intersect before calculating their new speed and heading
  
  ;; take the sum of both radii
  let radii ((size / 2) + ([size] of other-turtle / 2))
  
  ;; calculate the differences in position and the distance between the two turtles
  let delta-x (xcor - [xcor] of other-turtle)
  let delta-y (ycor - [ycor] of other-turtle)
  let dist (sqrt (delta-x ^ 2 + delta-y ^ 2))
  
  if (dist = 0.0)
  [
    set dist (radii + 1.0)
    set delta-x radii
    set delta-y 0.0
  ]
  
  ;; find the minimum translation distance used to move both turtles so they don't intersect
  let mtdfactor ((radii - dist) / dist)
  let mtd-x (delta-x * mtdfactor)
  let mtd-y (delta-y * mtdfactor)
  
  ;; calculate the inverse mass of both turtles
  let im1 (1 / mass)
  let im2 (1 / mass2)
  let imsum (im1 + im2)
  
  ;; move the current turtle a proportion of the minimum translation distance equal
  ;; to the inverse proportion of the its mass to the sum of both turtles' mass
  set xcor (xcor + (mtd-x * (im1 / imsum)))
  set ycor (ycor + (mtd-y * (im1 / imsum)))
  
  ;; do the same for the other turtle
  ask other-turtle
  [
    set xcor (xcor - (mtd-x * (im2 / imsum)))
    set ycor (ycor - (mtd-y * (im2 / imsum)))
  ]
  
  ;;; phase 1: initial setup
  
  ;; let theta be the angle from current turtle towards the other turtle
  
  ;; if the two turtles exist at the same coordinates, set theta to a random value.
  ;; otherwise, the turtles exist at two different points and theta can be meaningfully defined.
  
  let theta (random-float 360)
  if (xcor != [xcor] of other-turtle) or (ycor != [ycor] of other-turtle)
  [ set theta towards other-turtle ]

  ;;; phase 2: convert velocities to theta-based vector representation

  ;; now convert the current turtle's velocity from speed/heading representation
  ;; to components along theta and perpendicular to theta
  let v1t (speed * cos (theta - heading))
  let v1l (speed * sin (theta - heading))

  ;; do the same for the other turtle
  let v2t (speed2 * cos (theta - heading2))
  let v2l (speed2 * sin (theta - heading2))

  ;;; phase 3: manipulate vectors to implement collision

  ;; compute the velocity of the system's center of mass along theta
  let vcm (((mass * v1t) + (mass2 * v2t)) / (mass + mass2))

  ;; now compute the new velocity for each turtle along direction theta.
  ;; velocity perpendicular to theta is unaffected by a collision along theta,
  ;; so the next two lines actually implement the collision itself, in the
  ;; sense that the effects of the collision are exactly the following changes
  ;; in particle velocity.
  
  set v1t (2 * vcm - v1t)
  set v2t (2 * vcm - v2t)

  ;;; phase 4: convert back to normal speed/heading

  ;; now convert the current turtle's velocity vector into the new speed and heading
  set speed sqrt ((v1t ^ 2) + (v1l ^ 2))
  ;; if the magnitude of the velocity vector is 0, atan is undefined. but
  ;; speed will be 0, so heading is irrelevant anyway. therefore, in that
  ;; case we'll just leave it unmodified.
  if v1l != 0 or v1t != 0
  [ set heading (theta - (atan v1l v1t)) ]

  ;; do the same for the other turtle
  ask other-turtle
  [
    set speed sqrt ((v2t ^ 2) + (v2l ^ 2))
    if v2l != 0 or v2t != 0
    [ set heading (theta - (atan v2l v2t)) ]
  ]
end


;;;;;;;;;;;;;;;;;
;; BIKER MOVEMENT
;;;;;;;;;;;;;;;;;


to move-biker
  ;; biker procedure
  ;; move a biker forward according to its heading and internal movement
  
  ;; if the biker has no internal movement destination, move it forward in a 90 degrees heading
  ;; otherwise, move it towards its internal movement destination
  ifelse (empty? destination)
  [
    jump speed * tick-delta
  ]
  [
    ;; advance each destination waypoint forward to match the bikers' default movement
    let advanced-destination []
    foreach destination
    [
      let way-x ((item 0 ?1) + biker-speed * tick-delta)
      while [ way-x > max-pxcor ] [ set way-x (min-pxcor + way-x - max-pxcor - 1) ]
      let way-y (item 1 ?1)
      set advanced-destination (lput (list way-x way-y) advanced-destination)
    ]
    set destination advanced-destination
    
    ;; once all waypoints are updated, retrieve the first waypoint
    let waypoint first destination
    let way-x (item 0 waypoint)
    let way-y (item 1 waypoint)
    
    ;; accelerate to a maximum of 200% of the initial biker speed
    ifelse (speed >= (biker-speed * 2))
    [ set speed (biker-speed * 2) ]
    [ set speed (speed + 0.5) ]
    
    ;; move the biker towards the current destination waypoint
    ifelse ((distancexy way-x way-y) <= (speed * tick-delta))
    [
      setxy way-x way-y
      set destination (but-first destination)
    ]
    [
      set heading (towardsxy-noywrap way-x way-y)
      jump speed * tick-delta
    ]
    
    ;; if there are no waypoints left in the destination, restore the biker's natural movement
    if empty? destination
    [
      set moving-bikers (moving-bikers - 1)
      set speed biker-speed
      set heading 90
    ]
  ]
end


to change-rotation-position
  ;; biker procedure
  ;; order a biker to swap position with the next biker in rotation order
  
  ask bikers with [ movement-type = "rotation" ]
  [
    ;; find the position of the next biker in rotation order
    let my-movement-order movement-order
    let candidate one-of bikers with [ (movement-type = "rotation") and (movement-order = ((my-movement-order + 1) mod next-rotation-order)) ]
    let dest-x ([xcor] of candidate)
    let dest-y ([ycor] of candidate)
    
    ;; set the destination to the position of the next biker
    set destination (lput (list dest-x dest-y) destination)
    set moving-bikers (moving-bikers + 1)
  ]
end


to change-arrowhead-position
  ;; order arrowhead biker to move to the next arrowhead formation
  
  ;; move a biker forward if it was not a leader in the current leadership direction
  ;; move a biker backwards if it was a leader in a current leadership direction
  ask bikers with [ movement-type = "arrowhead" ]
  [
    ifelse (arrowhead-direction * movement-order) > (arrowhead-direction * arrowhead-leader)
    [ set destination (lput (list (xcor + 10) ycor) destination) ]
    [ set destination (lput (list (xcor - 10) ycor) destination) ]
    set moving-bikers (moving-bikers + 1)
  ]
  
  ;; the arrowhead leader is the next/previous biker depending on the current direction of leadership
  set arrowhead-leader (arrowhead-leader + arrowhead-direction)
  
  ;; the direction of leadership changes when the first/last biker in the formation becomes leader
  if (arrowhead-leader = (next-arrowhead-order - 1)) or (arrowhead-leader = 0)
  [ set arrowhead-direction (- arrowhead-direction) ]
end


to change-line-position
  ;; order line bikers to move to their next position
  
  ask bikers with [ (movement-type = "line_1") or (movement-type = "line_2") ]
  [
    ;; retrieve the line leader and next line order matching the biker's line formation
    let next-line-order next-line-1-order
    let line-leader line-1-leader
    if (movement-type = "line_2")
    [
      set next-line-order next-line-2-order
      set line-leader line-2-leader
    ]
    
    ;; find the position of the next biker in line
    let my-movement-order movement-order
    let my-movement-type movement-type
    let candidate one-of bikers with [ (movement-type = my-movement-type) and
                                       (movement-order = ((my-movement-order - 1) mod next-line-order)) ]
    let dest-x ([xcor] of candidate)
    let dest-y ([ycor] of candidate)
    
    ;; set the destination to the position of the next biker
    ;; the line leader takes the position of the tailing biker by going around the line
    ifelse (movement-order = line-leader)
    [
      if (movement-type = "line_1")
      [ set destination (list (list xcor (ycor - 8)) (list dest-x (ycor - 8)) (list dest-x dest-y)) ]
      if (movement-type = "line_2")
      [ set destination (list (list xcor (ycor + 8)) (list dest-x (ycor + 8)) (list dest-x dest-y)) ]
    ]
    [
      set destination (lput (list dest-x dest-y) destination)
    ]
    set moving-bikers (moving-bikers + 1)
  ]
  
  ;; the new line leader is the next biker in line order
  if (next-line-1-order > 0) [ set line-1-leader ((line-1-leader + 1) mod next-line-1-order) ]
  if (next-line-2-order > 0) [ set line-2-leader ((line-2-leader + 1) mod next-line-2-order) ]
end


to-report towardsxy-noywrap [ x y ]
  ;; turtle procedure
  ;; report the heading to other-turtle without vertical wrapping (even if allowed by the topology)
  
  ;; measure the shortest x component
  let x-component (x - xcor)
  if (x-component > max-pxcor) [ set x-component (x-component - world-width) ]
  if (x-component < min-pxcor) [ set x-component (x-component + world-width) ]
  ;; measure the y component without wrapping
  let y-component (y - ycor)
  
  ifelse x-component = 0 and y-component = 0
  [ report heading ]
  [ report atan x-component y-component ]
end


to check-for-biker-collision
  ;; biker procedure
  ;; check for collision between bikers, mark the collision and stop the simulation
  
  ;; collision occurs when the summed radii of both candidates exceeds their distance
  let my-who who
  let candidate one-of bikers in-radius biker-size with [ who < my-who ]
  
  ;; resolve the collision
  ;; candidates only collide if one candidate has non-zero speed
  if (candidate != nobody) and ((speed > 0) or ([speed] of candidate > 0))
  [
    ;; mark the collision point and specify that bikers have collided
    let mid-x ((xcor + ([xcor] of candidate)) / 2)
    let mid-y ((ycor + ([ycor] of candidate)) / 2)
    mark-collision mid-x mid-y
    set bikers-collided? true
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
10
10
974
283
100
25
4.75
1
20
1
1
1
0
1
1
1
-100
100
-25
25
1
1
1
ticks
30.0

BUTTON
10
400
120
440
Setup Particles
setup-particles
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
10
450
120
510
Go/Stop
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
160
300
330
333
number-of-particles
number-of-particles
10
1000
500
10
1
NIL
HORIZONTAL

SLIDER
160
386
330
419
number-of-bikers
number-of-bikers
1
8
8
1
1
NIL
HORIZONTAL

BUTTON
10
300
120
340
Setup World
setup-world
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
10
350
120
390
Setup Bikers
setup-bikers
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1270
10
1540
230
Collisions Over Time
time
collision rate
0.0
10.0
0.0
50.0
true
true
"" ""
PENS
"biker 1" 1.0 0 -10899396 true "" ""
"biker 2" 1.0 0 -2674135 true "" ""
"biker 3" 1.0 0 -6459832 true "" ""
"biker 4" 1.0 0 -8630108 true "" ""
"biker 5" 1.0 0 -13791810 true "" ""
"biker 6" 1.0 0 -5825686 true "" ""
"biker 7" 1.0 0 -955883 true "" ""
"biker 8" 1.0 0 -2064490 true "" ""

SWITCH
580
300
720
333
follow-biker?
follow-biker?
1
1
-1000

MONITOR
580
386
720
431
Biker Collisions
biker-x-collisions
2
1
11

PLOT
990
10
1260
230
Collisions Per Biker
bikers
collision rate
0.0
8.0
0.0
50.0
true
true
"" ""
PENS
"biker 1" 1.0 1 -10899396 true "" ""
"biker 2" 1.0 1 -2674135 true "" ""
"biker 3" 1.0 1 -6459832 true "" ""
"biker 4" 1.0 1 -8630108 true "" ""
"biker 5" 1.0 1 -13345367 true "" ""
"biker 6" 1.0 1 -5825686 true "" ""
"biker 7" 1.0 1 -955883 true "" ""
"biker 8" 1.0 1 -2064490 true "" ""

MONITOR
580
441
720
486
Biker Collision Percentage
biker-x-collisions-percentage
2
1
11

SLIDER
160
343
330
376
particle-initial-speed
particle-initial-speed
1
10
10
1
1
NIL
HORIZONTAL

SLIDER
160
429
330
462
biker-speed
biker-speed
1
5
5
1
1
NIL
HORIZONTAL

SLIDER
160
482
330
515
wind-angle
wind-angle
0
359
270
1
1
°
HORIZONTAL

SLIDER
160
525
330
558
wind-strength
wind-strength
0
10
10
1
1
NIL
HORIZONTAL

SLIDER
580
343
720
376
followed-biker
followed-biker
1
current-biker-number
1
1
1
NIL
HORIZONTAL

SLIDER
370
300
540
333
ground-slope
ground-slope
0
89
0
1
1
°
HORIZONTAL

SLIDER
370
343
540
376
friction-coefficient
friction-coefficient
0.1
2
0.2
0.1
1
NIL
HORIZONTAL

SLIDER
370
482
540
515
biker-number
biker-number
1
current-biker-number
1
1
1
NIL
HORIZONTAL

SLIDER
370
525
540
558
biker-mass
biker-mass
50
160
100
10
1
NIL
HORIZONTAL

MONITOR
580
506
720
551
Particle Average Speed
particle-avg-speed
3
1
11

PLOT
1270
240
1540
460
Biker Mass
biker number
biker mass
0.0
8.0
50.0
160.0
true
true
"" ""
PENS
"biker 1" 1.0 1 -10899396 true "" ""
"biker 2" 1.0 1 -2674135 true "" ""
"biker 3" 1.0 1 -6459832 true "" ""
"biker 4" 1.0 1 -8630108 true "" ""
"biker 5" 1.0 1 -13345367 true "" ""
"biker 6" 1.0 1 -5825686 true "" ""
"biker 7" 1.0 1 -955883 true "" ""
"biker 8" 1.0 1 -2064490 true "" ""

BUTTON
370
568
540
601
Apply Mass
apply-mass
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
370
386
540
419
slope-coefficient
slope-coefficient
0.1
2
0.2
0.1
1
NIL
HORIZONTAL

SLIDER
370
429
540
462
collision-coefficient
collision-coefficient
0
4
2
0.2
1
NIL
HORIZONTAL

PLOT
990
240
1260
460
Biker Pulse
time
biker pulse
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"biker 1" 1.0 0 -10899396 true "" ""
"biker 2" 1.0 0 -2674135 true "" ""
"biker 3" 1.0 0 -6459832 true "" ""
"biker 4" 1.0 0 -8630108 true "" ""
"biker 5" 1.0 0 -13345367 true "" ""
"biker 6" 1.0 0 -5825686 true "" ""
"biker 7" 1.0 0 -955883 true "" ""
"biker 8" 1.0 0 -2064490 true "" ""
"average" 1.0 0 -16777216 true "" ""

BUTTON
760
343
950
376
Select Rotating Bikers
select-rotating-bikers
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
760
515
950
548
Reset Movement
reset-moving-bikers
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
760
300
950
333
movement-interval
movement-interval
0
20
10
2
1
ticks
HORIZONTAL

BUTTON
760
386
950
419
Select Arrowhead Bikers
select-arrowhead-bikers
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
760
429
950
462
Select Line 1 Bikers
set selected-line 0\nselect-line-bikers
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
760
472
950
505
Select Line 2 Bikers
set selected-line 1\nselect-line-bikers
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

This model explores how bicycle riders move through the environment, what affects their movement and how they can move more efficiently. In particular, the model explores how bikers are affected by collision with air particles and how they can be arranged in various formations to minimise the negative effect of air friction.

This model introduces several biker movement tactics which define how the bikers move in relation to each other while still moving forward on the road. The model explores the use and effectiveness of these movement tactics.

## HOW IT WORKS

There are two types of agents in this model: particles and bikers.

Particles are placed randomly around the world and move in either random directions or in a specified direction as a simulation of wind. Particles can collide with each other or with bikers.

Bikers are placed manually on the world and move either at constant speed and direction or use one of the available movement tactics for specialized movement behaviour.

In addition to particles, there are additional variables to the world that can affect the bikers: ground slope, ground friction and biker mass.

Each biker maintains an attribute named `pulse` which represents the force exerted by the biker as it moves through the environment. A biker's pulse changes over time and is affected by collision with particles, the biker's mass, the ground slope and the ground friction.

Bikers can be selected to use one of several movement tactics:

1. **Rotation:** bikers exchange places with one another in a certain order.
2. **Arrowhead:** up to four bikers maintain an arrowhead formation, where each bikers periodically takes place at the tip of the arrowhead.
3. **Line:** bikers maintain up to two line formations, where each biker periodically move one spot forward in the line (the leading biker moves to the back of the line).

## HOW TO USE IT

### SETTING UP THE WORLD

Use the setup buttons to create a world and populate it with bikers and particles.

* **SETUP WORLD** -- creates an empty world without bikers or particles.
* **SETUP BIKERS** -- places bikers at the center of the world and allows to move them.
* **SETUP PARTICLES** -- adds particles at random locations to the world.

Initial parameters:

* **NUMBER-OF-PARTICLES** -- determines how many particles are added to the world.
* **PARTICLE-INITIAL-SPEED** -- determines the particles' starting speed.
* **NUMBER-OF-BIKERS** -- determines how many bikers are placed in the world.
* **BIKER-SPEED** -- determines the bikers' speed.

After setting up the world, the model can be run using the **GO** button.

### ADDITIONAL PARAMETERS

Additional parameters available are:

  1. Wind influence (angle and strength)
  2. Ground influence (slope and friction)
  3. Biker mass

Wind influence is determined by angle and strength.

* **WIND-ANGLE** -- determines the direction in which air particles will move.
* **WIND-STRENGTH** -- determines how strongly particles will be pulled in that direction.

Ground influence is determined by slope and friction.

* **GROUND-SLOPE** -- determines the angle (slope) of the road
* **FRICTION-COEFFICIENT** -- determines the strength of friction of the road

All bikers begin with identical mass by default. Each biker's mass can be modified by choosing the desired biker number and mass value, and applying the mass to the biker.

* **BIKER-NUMBER** -- determines to which biker the new mass will be applied.
* **BIKER-MASS** -- determines the mass value applied to the selected biker.
* **APPLY MASS** -- applies the selected mass value to the selected biker.

The **BIKER MASS** plot displays the bikers' current mass.

### BIKER MOVEMENT

In order to select bikers to use one of the possible movement tactics, activate the appropriate button and click on the desired bikers in order to select them.

* **ROTATING BIKERS** -- selects bikers to use the rotation tactic
* **ARROWHEAD BIKERS** -- selects bikers to use the arrowhead tactic
* **LINE 1 BIKERS** -- selects bikers to use the line tactic in the first line
* **LINE 2 BIKERS** -- selects bikers to use the line tactic in the second line
* **RESET MOVEMENT** -- resets all movement tactic selections

Bikers selected to use the rotation tactic will periodically swap locations with one another in the order in which they were selected. Rotating bikers are coloured light to dark blue in the order of selection.

Bikers selected to use the arrowhead tactic or either line tactic will automatically be moved to the desired location upon selection and should not be moved further. Arrowhead bikers are coloured purple. Line bikers are coloured light cyan for the first line and dark cyan for the second line.

The **MOVEMENT-INTERVAL** slider determines the time period (measured in ticks) between position changes for each movement tactic (how bikers change their position depends on their selected tactic).

### OUTPUT

Information on particles:

* **PARTICLE AVERAGE SPEED** -- shows the average movement speed of all particles.

Information on bikers:

* **COLLISIONS PER BIKER** -- shows the bikers' recent number of collisions with particles.
* **COLLISIONS OVER TIME** -- shows the bikers' number of collisions with particles over time.
* **BIKER PULSE** -- shows the bikers' pulse over time.
* **BIKER MASS** -- shows the bikers' current mass.

It is possible to focus on a specific biker in order to highlight it in the world view and receive information on its collision rate with particles.

* **FOLLOW-BIKER?** -- determines whether or not to follow a specific biker.
* **FOLLOWED-BIKER** -- determines which biker is being followed.
* **BIKER COLLISIONS** -- shows the followed biker's total number of collisions with particles.
* **BIKER COLLISION PERCENTAGE** -- shows the percentage of the followed biker's collisions with particles out of all biker collisions with particles.

## THINGS TO NOTICE

How does collision with particles affect the bikers? Pay attention to the biker pulse as it changes over time in relation to the biker collision rate with particles.

How does collision with bikers affect the particles? When arranged in different formations, can bikers shield each other from these collisions?

How does the presence of wind influence the way particles move and collide with bikers?

How are bikers affected by their mass, as well as the slope and friction of the ground?

How do the different movement tactics help the bikers move more efficiently? How are bikers affected when using these tactics compared to their default movement? What is the difference between the different tactics?

## THINGS TO TRY

Try moving the bikers and placing them in different formations.

How do you judge the effectiveness of a formation? Is it useful to reduce the pulse of certain bikers at the expense of other bikers?

Try changing the direction and strength of the wind.

How does wind influence the effectiveness of biker formations?

Try increasing and decreasing the ground slope and friction and assigning different mass values to the bikers.

How does the bikers' pulse change in relation to the ground slope and friction?

What value of mass is more desirable for a biker in order to minimise its pulse?

Try out the different movement tactics and see how bikers are affected. Pay attention to each biker's pulse as the biker changes positions as part of the tactic.

How are each of these tactics useful compared to the others and the default biker movement? How are they different from one another?

## EXTENDING THE MODEL

This model extends the **Particles and Bikers Basic** model with more sophisticated biker movement tactics.

The model only defines a few types of biker movement tactics and can be extended with new kinds of tactics in order to test them.

In addition, the model can be extended to allow for more complex and realistic relationships between the bikers and the environment. This would require introducing more complex rules to the model.

## NETLOGO FEATURES

Notice the need to define an `arctan` procedure to calculate the arctangent value for a single argument. NetLogo only offers the two-argument variant of arctangent (`atan`).

The `in-radius` agent reporter is used to detect collisions by looking for particles or bikers within a certain radius from another particle. This method proved more time effective than testing the distance between every two turtles using the `with` reporter.

## RELATED MODELS

* Particles and Bikers Basic
* Particles and Bikers with Flocking

## CREDITS AND REFERENCES

This model was created by two pairs of computer science students at the University of Haifa, as part of a project course led by Hananel Hazan. It is based on the models "NetLogo Connected Chemistry 3 Circular Particles" (Wilensky, 2005) and "Atmosphere" (Wilensky, 1997).

To cite the model please use the following:

Bacalo, Y.; Kakoon, A.; Asaf, A.; Zar, L.; Hirsh, A. & Levy S.T. (2011). Of Particles and Bikers With Movement model. The model was constructed by third-year undergraduate computer science students at the University of Haifa as part of their final projects in a course taught by Mr. Hananel Hazan, named “Project Course”. Faculty of Education, University of Haifa. 
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
