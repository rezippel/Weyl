(in-package 'weyl)

(defmacro def-grobner-test (name args coefs vars &body body)
  `(defun ,name (,@args &optional (compare-fn :lexical))
     (let* ((r (get-polynomial-ring ,coefs ',vars))
            ,@(loop for var in vars
                    collect `(,var (coerce ',var r)))
            (b (make-instance 'weyli::grobner-basis
                              :ring r
                              :greater-function compare-fn)))
       (weyli::reset-grobner-basis b)
       ,@body
       (time (reduce-basis b))
       b)))

(def-grobner-test test-1 ()
    (get-rational-numbers) (x y)
  (weyli::add-relation b (+ (* x x) (* y y)))
  (weyli::add-relation b (* x y)))
  
;; This one takes a long time 
(def-grobner-test test-2 ()
    (get-rational-numbers) (x z u v)
  (let ((h1 (+ (* x x x) (* 2 x)))
        (h2 (+ (* x x) (* x z z))))
    (weyli::add-relation b (+ (* h1 h1 h1) (* h1 h2)))
    (weyli::add-relation b (- u h1))
    (weyli::add-relation b (- v h2))))

(def-grobner-test test-3 ()
    (get-rational-numbers) (x y)
  (let* ((h (+ (* x x) (* 2 x))))
    (weyli::add-relation b (+ (* h h h) (* 3 h h)))
    (weyli::add-relation b (- h y))))

(def-grobner-test test-4 ()
    (get-rational-numbers) (x y)
  (weyli::add-relation b (+ (* x x x) (* y y y)))
  (weyli::add-relation b (+ (* x x) (* y y))))

(def-grobner-test test-4a ()
    (get-quotient-field (get-polynomial-ring (get-rational-integers) '(a)))
    (x y)
  (let ((a (coerce 'a r)))
    (add-relation b (- (+ (* x x) (* y y y)) a))
    (add-relation b (- (+ (* x y) (* y y)) (- 1 a)))))

(def-grobner-test test-4b ()
    (get-quotient-field (get-polynomial-ring (get-rational-integers) '(a)))
    (x y z)
  (let ((a (coerce 'a r)))
    (add-relation b (- (+ (* x x) (* y y) (* z z))
                       a))
    (add-relation b (+ x y z -1))
    (add-relation b (- (+ (* x y) (* y z) (* x z))
                       (- 1 a)))))

(def-grobner-test test-5 ()
    (get-rational-numbers) (x y)
  (weyli::add-relation b (+ x y -3))
  (weyli::add-relation b (+ (expt x 2) (expt y 2) -5)))

(def-grobner-test test-5b ()
    (get-quotient-field (get-polynomial-ring (get-finite-field 163) '(s)))
    (x y)
    (let ((s (coerce 's r)))

      (weyli::add-relation b (+ x (* y (+ 1 s)) -3))
      (weyli::add-relation b (+ (expt x 2) (expt y 2) -5))))

(def-grobner-test test-6 ()
    (get-rational-numbers) (x y z)
  (weyli::add-relation b (+ x y z -6))
  (weyli::add-relation b (+ (expt x 2) (expt y 2) (expt z 2) -14))
  (weyli::add-relation b (+ (expt x 4) (expt y 4) (expt z 4) -98)))

(def-grobner-test test-tet ()
  (get-rational-numbers) (x2 y2 x3 y3 z3)
  (let ((x0 0) (y0 0) (z0 0)
        (x1 1) (y1 0) (z1 0)
        (z2 0))
    (macrolet ((dist (i j)
                 `(weyli::add-relation b
                    (+ (expt (- ,(intern (format nil "X~D" i))
                                ,(intern (format nil "X~D" j))) 2)
                       (expt (- ,(intern (format nil "Y~D" i))
                                ,(intern (format nil "Y~D" j))) 2)
                       (expt (- ,(intern (format nil "Z~D" i))
                                ,(intern (format nil "Z~D" j))) 2)
                       -1))))
      ;(dist 0 1)
      (dist 0 2)
      (dist 1 2)
      (dist 0 3)
      (dist 1 3)
      (dist 2 3)
      )))

(def-grobner-test test-square ()
  (get-rational-numbers) (x4 y4 x5 y5 x6 y6 x7 y7)
  (let ((x0 0) (y0 0) (z0 0)
        (x1 1) (y1 0) (z1 0)
        (x2 0) (y2 1) (z2 0)
        (x3 1) (y3 1) (z3 0)
        (z4 1) (z5 1) (z6 1) (z7 1))
    (macrolet ((dist (i j)
                 `(weyli::add-relation b
                    (+ (expt (- ,(intern (format nil "X~D" i))
                                ,(intern (format nil "X~D" j))) 2)
                       (expt (- ,(intern (format nil "Y~D" i))
                                ,(intern (format nil "Y~D" j))) 2)
                       (expt (- ,(intern (format nil "Z~D" i))
                                ,(intern (format nil "Z~D" j))) 2)
                       -1))))
      (dist 0 7)
      (dist 1 4)
      (dist 2 5)
      (dist 3 6)
      (dist 4 5)
      (dist 5 6)
      (dist 6 7)
      (dist 7 4)
            
      )))

(def-grobner-test test-7 ()
    (get-rational-numbers) (x y z)
  (weyli::add-relation b (- (* x x x y z) (* x z z)))
  (weyli::add-relation b (- (* x y y z) (* x y z)))
  (weyli::add-relation b (- (* x x y y) (* z z))))

(def-grobner-test test-8 ()
    (get-rational-numbers) (x y z)
  (weyli::add-relation b (+ (* 4 x x) (* x y y) (- z) (coerce 1/4 r)))
  (weyli::add-relation b (+ (* 2 x) (* y y z) (coerce 1/2 r)))
  (weyli::add-relation b (+ (* x x z) (* (coerce -1/2 r) x) (* -1 y y))))

(def-grobner-test test-9 ()
    (get-rational-numbers) (x y z w)
  (weyli::add-relation b (+ x y z w -10))
  (weyli::add-relation b (+ (expt x 2) (expt y 2) (expt z 2) (expt w 2) -22))
  (weyli::add-relation b (+ (expt x 3) (expt y 3) (expt z 3) (expt w 3) -100))    
  (weyli::add-relation b (+ (expt x 4) (expt y 4) (expt z 4) (expt w 4) -354)))

(def-grobner-test test-10 ()
    (get-rational-numbers) (x y)
  (weyli::add-relation b (+ x y 3))
  (weyli::add-relation b (+ x (- y) 1)))

(def-grobner-test test-11 (n)
    (get-rational-numbers) (x y z)
  (weyli::add-relation b (+ (expt x n) y 1))
  (weyli::add-relation b (+ (* x y) z 3))
  (weyli::add-relation b (+ (* x z) z 5)))

(defun do-grobner-tests (tests &optional (stream *standard-output*))
  (macrolet ((do-test (name &body test)
		      `(progn 
			 (format stream "~3%~A~%" ,name)
			 (print (progn . ,test)))))
    (loop for test in tests do
	  (case test
	    (1 (do-test "Test 1:" (test-1)))
	    (2 (do-test "Test 2:" (test-2 :revlex)))
	    (3 (do-test "Test 3:" (test-3)))
	    (4 (do-test "Test 4:" (test-4)))
	    (5 (do-test "Test 5:" (test-5)))
	    (6 (do-test "Test 6:" (test-6)))
	    (7 (do-test "Test 7:" (test-7)))
	    (8 (do-test "Test 8:" (test-8)))
	    (9 (do-test "Test 9:" (test-9)))
	    (10 (do-test "Test 10:" (test-10)))
	    (11 (do-test "Test 11 (4):" (test-11 4)))))))


(defun do-all-tests (&optional (stream *standard-output*))
  (macrolet ((do-test (name &body test)
               `(progn 
                  (format stream "~3%~A~%" ,name)
                  (print (progn . ,test)))))
    (do-test "Test 1:" (test-1))
    (do-test "Test 2:" (test-2 :revlex))
    (do-test "Test 3:" (test-3))
    (do-test "Test 4:" (test-4))
    (do-test "Test 5:" (test-5))
    (do-test "Test 6:" (test-6))
    (do-test "Test 7:" (test-7))
    (do-test "Test 8:" (test-8))
    (do-test "Test 9:" (test-9))
    (do-test "Test 10:" (test-10))
    (do-test "Test 11 (4):" (test-11 4))))
