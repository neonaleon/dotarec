;; to begin program, call (batch "main.bat")

;; remove previous loaded constructs
(clear)

;; load files here
(load "heroes.clp")
(load "ui.clp")

;; start running program
(reset)
(hero-selection begin) ;; by right should be called by program logic in ui.clp
(run)