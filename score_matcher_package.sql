-- ========================================
-- PACKAGE SPECIFICATION
-- ========================================
CREATE OR REPLACE PACKAGE score_matcher_pkg
IS
    -- Function signature
    FUNCTION calculate_score_points(
        forecast_team1 IN NUMBER,
        forecast_team2 IN NUMBER,
        actual_team1 IN NUMBER,
        actual_team2 IN NUMBER
    ) RETURN NUMBER;
    
    -- Procedure signature
    PROCEDURE calculate_score_points_proc(
        forecast_team1 IN NUMBER,
        forecast_team2 IN NUMBER,
        actual_team1 IN NUMBER,
        actual_team2 IN NUMBER,
        points_out OUT NUMBER
    );
    
END score_matcher_pkg;
/


-- ========================================
-- PACKAGE BODY
-- ========================================
CREATE OR REPLACE PACKAGE BODY score_matcher_pkg
IS
    -- Internal helper function used by both function and procedure
    FUNCTION get_match_result(team1 IN NUMBER, team2 IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
        IF team1 > team2 THEN
            RETURN 'W';
        ELSIF team1 < team2 THEN
            RETURN 'L';
        ELSE
            RETURN 'T';
        END IF;
    END get_match_result;
    
    -- ========================================
    -- FUNCTION IMPLEMENTATION
    -- ========================================
    FUNCTION calculate_score_points(
        forecast_team1 IN NUMBER,
        forecast_team2 IN NUMBER,
        actual_team1 IN NUMBER,
        actual_team2 IN NUMBER
    ) RETURN NUMBER
    IS
        forecast_result VARCHAR2(1);
        actual_result VARCHAR2(1);
        points NUMBER := 0;
    BEGIN
        -- Check if scores match exactly (jackpot - 100% match)
        IF forecast_team1 = actual_team1 AND forecast_team2 = actual_team2 THEN
            points := 5;
        ELSE
            -- Determine forecast and actual results using internal function
            forecast_result := get_match_result(forecast_team1, forecast_team2);
            actual_result := get_match_result(actual_team1, actual_team2);
            
            -- Check if the match result is correct (but score is different)
            IF forecast_result = actual_result THEN
                points := 2;
            END IF;
        END IF;
        
        RETURN points;
    END calculate_score_points;
    
    -- ========================================
    -- PROCEDURE IMPLEMENTATION
    -- ========================================
    PROCEDURE calculate_score_points_proc(
        forecast_team1 IN NUMBER,
        forecast_team2 IN NUMBER,
        actual_team1 IN NUMBER,
        actual_team2 IN NUMBER,
        points_out OUT NUMBER
    )
    IS
        forecast_result VARCHAR2(1);
        actual_result VARCHAR2(1);
        points NUMBER := 0;
    BEGIN
        -- Check if scores match exactly (jackpot - 100% match)
        IF forecast_team1 = actual_team1 AND forecast_team2 = actual_team2 THEN
            points := 5;
        ELSE
            -- Determine forecast and actual results using internal function
            forecast_result := get_match_result(forecast_team1, forecast_team2);
            actual_result := get_match_result(actual_team1, actual_team2);
            
            -- Check if the match result is correct (but score is different)
            IF forecast_result = actual_result THEN
                points := 2;
            END IF;
        END IF;
        
        -- Assign the result to the OUT parameter
        points_out := points;
    END calculate_score_points_proc;
    
END score_matcher_pkg;
/
