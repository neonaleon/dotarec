;; to begin program, call (batch "main.bat")

;; remove previous loaded constructs
(clear)

;; load files here
(load "templates.clp")
(load "facts.clp")
(load "functions.clp")
(load "heroes.clp")
(load "items.clp")
(load "recommend.clp")
(load "vote.clp")
(load "ui.clp")

;; start running program
(reset)
(run)