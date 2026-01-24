-- ========================================
-- TEST CASES FOR calculate_score_points
-- ========================================

-- ========================================
-- 100% MATCH TEST CASES (Expected: 5 points)
-- ========================================

-- Test 1: Exact match - Team 1 wins 2-1
SELECT calculate_score_points(2, 1, 2, 1) AS points_100_percent_match
FROM dual;

-- Test 2: Exact match - Tie 1-1
SELECT calculate_score_points(1, 1, 1, 1) AS points_tie_exact_match
FROM dual;

-- Test 3: Exact match - Team 1 loses 0-3
SELECT calculate_score_points(0, 3, 0, 3) AS points_team1_loses_exact
FROM dual;


-- ========================================
-- PARTIAL MATCH TEST CASES (Expected: 2 points)
-- ========================================

-- Test 4: Partial match - Predicted tie 1-1, actual tie 2-2
SELECT calculate_score_points(1, 1, 2, 2) AS points_partial_tie
FROM dual;

-- Test 5: Partial match - Predicted Team 1 wins 2-0, actual Team 1 wins 3-1
SELECT calculate_score_points(2, 0, 3, 1) AS points_partial_team1_wins
FROM dual;

-- Test 6: Partial match - Predicted Team 1 loses 1-3, actual Team 1 loses 0-2
SELECT calculate_score_points(1, 3, 0, 2) AS points_partial_team1_loses
FROM dual;


-- ========================================
-- WRONG PREDICTION TEST CASES (Expected: 0 points)
-- ========================================

-- Test 7: Wrong prediction - Predicted Team 1 wins, Team 2 actually wins
SELECT calculate_score_points(2, 1, 1, 3) AS points_wrong_result
FROM dual;

-- Test 8: Wrong prediction - Predicted tie, Team 1 actually wins
SELECT calculate_score_points(1, 1, 2, 0) AS points_tie_wrong
FROM dual;


-- ========================================
-- ANONYMOUS PL/SQL BLOCKS (BEGIN-END)
-- ========================================

-- Test 9: Using BEGIN-END block for 100% match
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 9 - 100% Match (2-1):');
    DBMS_OUTPUT.PUT_LINE('Points: ' || calculate_score_points(2, 1, 2, 1));
    DBMS_OUTPUT.NEW_LINE;
END;
/

-- Test 10: Using BEGIN-END block for partial match (tie)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 10 - Partial Match (Tie 1-1 vs 2-2):');
    DBMS_OUTPUT.PUT_LINE('Points: ' || calculate_score_points(1, 1, 2, 2));
    DBMS_OUTPUT.NEW_LINE;
END;
/

-- Test 11: Using BEGIN-END block for partial match (first team wins)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 11 - Partial Match (Team 1 Wins 2-0 vs 3-1):');
    DBMS_OUTPUT.PUT_LINE('Points: ' || calculate_score_points(2, 0, 3, 1));
    DBMS_OUTPUT.NEW_LINE;
END;
/

-- Test 12: Using BEGIN-END block for partial match (first team loses)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 12 - Partial Match (Team 1 Loses 1-3 vs 0-2):');
    DBMS_OUTPUT.PUT_LINE('Points: ' || calculate_score_points(1, 3, 0, 2));
    DBMS_OUTPUT.NEW_LINE;
END;
/

-- Test 13: Using BEGIN-END block with variable assignment
DECLARE
    v_points NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 13 - Wrong Prediction (Predicted 2-1, Actual 1-3):');
    v_points := calculate_score_points(2, 1, 1, 3);
    DBMS_OUTPUT.PUT_LINE('Points: ' || v_points);
    
    IF v_points = 5 THEN
        DBMS_OUTPUT.PUT_LINE('Result: JACKPOT - 100% Match!');
    ELSIF v_points = 2 THEN
        DBMS_OUTPUT.PUT_LINE('Result: GOOD - Correct prediction!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Result: MISS - Wrong prediction');
    END IF;
    DBMS_OUTPUT.NEW_LINE;
END;
/

-- Test 14: Comprehensive test with loop
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
        test_case(1, 1, 2, 2, 'Partial Match: Tie (predicted 1-1, actual 2-2)'),
        test_case(2, 0, 3, 1, 'Partial Match: Team 1 Wins (predicted 2-0, actual 3-1)'),
        test_case(1, 3, 0, 2, 'Partial Match: Team 1 Loses (predicted 1-3, actual 0-2)'),
        test_case(2, 1, 1, 3, 'Wrong: Predicted Team 1 wins, Team 2 wins instead')
    );
    
    v_points NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('COMPREHENSIVE TEST RESULTS');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.NEW_LINE;
    
    FOR i IN 1 .. v_tests.COUNT LOOP
        v_points := calculate_score_points(
            v_tests(i).forecast_t1,
            v_tests(i).forecast_t2,
            v_tests(i).actual_t1,
            v_tests(i).actual_t2
        );
        
        DBMS_OUTPUT.PUT_LINE('Test ' || i || ': ' || v_tests(i).description);
        DBMS_OUTPUT.PUT_LINE('  Forecast: ' || v_tests(i).forecast_t1 || '-' || v_tests(i).forecast_t2 || 
                             ' | Actual: ' || v_tests(i).actual_t1 || '-' || v_tests(i).actual_t2);
        DBMS_OUTPUT.PUT_LINE('  Points: ' || v_points);
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('========================================');
END;
/
