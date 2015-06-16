#lang racket
(require web-server/servlet
         web-server/servlet-env
         web-server/http)

;; Constants
(define POST-DEATH 1800)
(define NAME "HateStack")
(define DEFAULT-TITLE "Frothing Hatred")
(define DEFAULT-AUTHOR "Angry Loudmouth")
(define MAX-POSTS 20)

;; Structs
(struct stack (posts) #:mutable)

(struct post (title author body created) #:mutable)

;; Establish the HATE
(define HATE (stack (list (post (string-append "Welcome to " NAME)
                                DEFAULT-AUTHOR
                                "This is a place for rants. All is forgotten."
                                (current-seconds)))))

;; Functions
(define (old-post? p)
  (> (current-seconds) (+ (post-created p) POST-DEATH)))

(define (check-posts s)
  (set-stack-posts! HATE (for/list ((i (stack-posts s))
                                    (j (in-range MAX-POSTS))
                                    #:unless (old-post? i))
                           i)))

(define (add-post title name body)
  (set-stack-posts! HATE (cons (post (if (string=? title "") DEFAULT-TITLE title)
                                     (if (string=? name "") DEFAULT-AUTHOR name)
                                     body
                                     (current-seconds))
                               (stack-posts HATE))))

(define (render-post p)
  `(div ((class "panel panel-default"))
        (div ((class "panel-heading")) (h4 ,(post-title p)))
        (div ((class "panel-body")) (p ,(post-body p)))
        (div ((class "panel-footer")) (em ,(post-author p)))))

(define (render-posts s)
  (check-posts HATE)
  `(div ((class "container"))
        ,@(map render-post (stack-posts s))))

(define (render-bar)
  `(nav ((class "navbar navbar-default")
         (role "navigation"))
        (div ((class "container-fluid"))
             (div ((class "navbar-header"))
                  (a ((class "navbar-brand")
                      (href "#"))
                     ,NAME)))))

(define (render-jumbotron)
  `(div ((class "jumbotron"))
        (fieldset 
         (legend "Add Your Rant")
         (form 
          (div ((class "row"))
               (div ((class "col-md-8"))
                    (div ((class "form-group"))
                         (label ((for "Title") (class "control-label")) "Title")
                         (input ((type "text") 
                                 (class "form-control") 
                                 (name "Title") 
                                 (placeholder ,DEFAULT-TITLE)))))
               (div ((class "col-md-4"))
                    (div ((class "form-group"))
                         (label ((for "Title") (class "control-label")) "Name")
                         (input ((type "text") 
                                 (class "form-control") 
                                 (name "Name") 
                                 (placeholder ,DEFAULT-AUTHOR))))))
          (div ((class "row"))
               (div ((class "form-group"))
                    (label ((for "Post") (class "col-lg-2 control-label")) "Your Rant")
                    (div ((class "col-lg-10"))
                         (textarea ((class "form-control") (rows "5") (name "Post"))))))
          (div ((class "row"))
               (div ((class "col-lg-10 col-lg-offset-2"))
                    (div ((class "form-group"))
                         (button ((type "submit") (class "btn btn-primary")) "Submit")
                         (button ((type "reset") (class "btn btn-default")) "Cancel"))))))))

(define (render-page)
  (response/xexpr
   #:preamble #"<!DOCTYPE html>"
   `(html (head (title ,NAME)
                (link ((rel "stylesheet")
                       (href "//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css")))
                (link ((rel "stylesheet")
                       (href "//maxcdn.bootstrapcdn.com/bootswatch/3.2.0/journal/bootstrap.min.css")))
                (script ((src "//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"))))
          (body (div ((class "col-lg-10"))
                     ,(render-bar)
                     (div ((class "col-lg 8"))
                          (div ((class "container")) ,(render-jumbotron))
                          ,(render-posts HATE)))))))

(define (start req)
  (let ((bindings (request-bindings req)))
    (when (for/and ((i '(title name post)))
            (exists-binding? i bindings))
      (add-post (extract-binding/single 'title bindings)
                (extract-binding/single 'name bindings)
                (extract-binding/single 'post bindings)))
    (render-page)))

;; Main Server startup
(serve/servlet start
               #:servlet-regexp #rx""
               #:servlet-path "/"
               #:port 8080)