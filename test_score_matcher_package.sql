-- ========================================
-- TEST CASES FOR SCORE_MATCHER_PKG
-- ========================================

-- ========================================
-- FUNCTION CALL EXAMPLES (Using package)
-- ========================================

-- Test 1: Function call with SELECT (100% match)
SELECT score_matcher_pkg.calculate_score_points(2, 1, 2, 1) AS points
FROM dual;

-- Test 2: Function call with SELECT (Partial match - tie)
SELECT score_matcher_pkg.calculate_score_points(1, 1, 2, 2) AS points
FROM dual;

-- Test 3: Function call with SELECT (Wrong prediction)
SELECT score_matcher_pkg.calculate_score_points(2, 1, 1, 3) AS points
FROM dual;


-- ========================================
-- PROCEDURE CALL EXAMPLES (Using package)
-- ========================================

-- Test 4: Simple procedure call with OUT parameter
DECLARE
    v_points NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 4 - Procedure Call (100% Match 2-1):');
    score_matcher_pkg.calculate_score_points_proc(2, 1, 2, 1, v_points);
    DBMS_OUTPUT.PUT_LINE('Points: ' || v_points);
    DBMS_OUTPUT.NEW_LINE;
END;
/


-- Test 5: Procedure call with conditional logic
DECLARE
    v_points NUMBER;
    v_result_message VARCHAR2(100);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 5 - Procedure with Conditional (Partial Match Tie):');
    score_matcher_pkg.calculate_score_points_proc(1, 1, 2, 2, v_points);
    
    IF v_points = 5 THEN
        v_result_message := 'JACKPOT - 100% Match!';
    ELSIF v_points = 2 THEN
        v_result_message := 'GOOD - Correct Prediction!';
    ELSE
        v_result_message := 'MISS - Wrong Prediction';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Points: ' || v_points);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_result_message);
    DBMS_OUTPUT.NEW_LINE;
END;
/


-- Test 6: Procedure call with Team 1 wins (partial match)
DECLARE
    v_points NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 6 - Procedure (Partial Match Team 1 Wins):');
    DBMS_OUTPUT.PUT_LINE('Predicted: 2-0 | Actual: 3-1');
    score_matcher_pkg.calculate_score_points_proc(2, 0, 3, 1, v_points);
    DBMS_OUTPUT.PUT_LINE('Points: ' || v_points);
    DBMS_OUTPUT.NEW_LINE;
END;
/


-- Test 7: Procedure call with Team 1 loses (partial match)
DECLARE
    v_points NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 7 - Procedure (Partial Match Team 1 Loses):');
    DBMS_OUTPUT.PUT_LINE('Predicted: 1-3 | Actual: 0-2');
    score_matcher_pkg.calculate_score_points_proc(1, 3, 0, 2, v_points);
    DBMS_OUTPUT.PUT_LINE('Points: ' || v_points);
    DBMS_OUTPUT.NEW_LINE;
END;
/


-- ========================================
-- MIXED FUNCTION AND PROCEDURE CALLS
-- ========================================

-- Test 8: Compare function and procedure results
DECLARE
    v_points_func NUMBER;
    v_points_proc NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 8 - Function vs Procedure Comparison:');
    
    -- Function call
    v_points_func := score_matcher_pkg.calculate_score_points(2, 1, 1, 3);
    
    -- Procedure call
    score_matcher_pkg.calculate_score_points_proc(2, 1, 1, 3, v_points_proc);
    
    DBMS_OUTPUT.PUT_LINE('Forecast: 2-1 | Actual: 1-3');
    DBMS_OUTPUT.PUT_LINE('Function Result: ' || v_points_func);
    DBMS_OUTPUT.PUT_LINE('Procedure Result: ' || v_points_proc);
    DBMS_OUTPUT.PUT_LINE('Match: ' || CASE WHEN v_points_func = v_points_proc THEN 'YES' ELSE 'NO' END);
    DBMS_OUTPUT.NEW_LINE;
END;
/


-- ========================================
-- COMPREHENSIVE TEST WITH LOOP
-- ========================================

-- Test 9: Bulk test using collections
DECLARE
    TYPE test_case IS RECORD (
        forecast_t1 NUMBER,
        forecast_t2 NUMBER,
        actual_t1 NUMBER,
        actual_t2 NUMBER,
        description VARCHAR2(100)
    );
    
    TYPE test_cases_table IS TABLE OF test_case;
    
    v_tests test_cases_table := test_cases_table(
        test_case(2, 1, 2, 1, '100% Match: 2-1'),
        test_case(1, 1, 1, 1, '100% Match: Tie 1-1'),
        test_case(0, 3, 0, 3, '100% Match: Team 1 Loses 0-3'),
        test_case(1, 1, 2, 2, 'Partial Match: Tie (1-1 vs 2-2)'),
        test_case(2, 0, 3, 1, 'Partial Match: Team 1 Wins (2-0 vs 3-1)'),
        test_case(1, 3, 0, 2, 'Partial Match: Team 1 Loses (1-3 vs 0-2)'),
        test_case(2, 1, 1, 3, 'Wrong: Predicted Team 1 wins, Team 2 wins instead')
    );
    
    v_points_func NUMBER;
    v_points_proc NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('COMPREHENSIVE PACKAGE TEST RESULTS');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.NEW_LINE;
    
    FOR i IN 1 .. v_tests.COUNT LOOP
        -- Function call
        v_points_func := score_matcher_pkg.calculate_score_points(
            v_tests(i).forecast_t1,
            v_tests(i).forecast_t2,
            v_tests(i).actual_t1,
            v_tests(i).actual_t2
        );
        
        -- Procedure call
        score_matcher_pkg.calculate_score_points_proc(
            v_tests(i).forecast_t1,
            v_tests(i).forecast_t2,
            v_tests(i).actual_t1,
            v_tests(i).actual_t2,
            v_points_proc
        );
        
        DBMS_OUTPUT.PUT_LINE('Test ' || i || ': ' || v_tests(i).description);
        DBMS_OUTPUT.PUT_LINE('  Forecast: ' || v_tests(i).forecast_t1 || '-' || v_tests(i).forecast_t2 || 
                             ' | Actual: ' || v_tests(i).actual_t1 || '-' || v_tests(i).actual_t2);
        DBMS_OUTPUT.PUT_LINE('  Function Points: ' || v_points_func || ' | Procedure Points: ' || v_points_proc);
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('========================================');
END;
/


-- ========================================
-- SYNTAX COMPARISON SUMMARY
-- ========================================
-- 
-- FUNCTION CALL:
--   - Can be used directly in SELECT statements
--   - Returns a value directly
--   - Syntax: SELECT package_name.function_name(param1, param2) FROM dual;
--   - Can be assigned: v_result := package_name.function_name(param1, param2);
--
-- PROCEDURE CALL:
--   - Cannot be used in SELECT statements directly
--   - Returns values via OUT parameters
--   - Syntax: package_name.procedure_name(param1, param2, out_param);
--   - Must be called in a BEGIN-END block (DECLARE section optional)
--   - More suitable for complex operations with multiple outputs
--
-- PACKAGE BENEFITS:
--   - Single namespace for related functions and procedures
--   - Shared internal helper functions (get_match_result in this case)
--   - Better code organization and reusability
--   - Can maintain state through package-level variables (if needed)
--
