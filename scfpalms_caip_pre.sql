/* This report gathers completed answers to the CAIP PRE course feedback activity */

--Setting up the column header with question names
SELECT
" " as UserID,
"1. How old are you%%Q%% (In years.)" as PreQ1, 
"2. To which gender category do you most identify with%%Q%%" as PreQ2,
"3. If you selected 'Other' for question #2, to which gender category do you most identify with%%Q%%" as PreQ3,
"4. Are you of Hispanic, Latinx or of Spanish origin%%Q%%" as PreQ4,
"5. How would you describe yourself%%Q%% (One or more categories may be selected.)" as PreQ5,
"6. If you selected 'Other' for question #5, how would you describe yourself%%Q%%" as PreQ6,
"7. What is your marital status%%Q%%"  as PreQ7,
"8. What is the highest degree or level of school you have completed%%Q%% (If you are currently enrolled in school, please indicate the highest degree you have received.)"  as PreQ8,
"9. If you selected 'Other' for question #8, What is the highest degree or level of school you have completed%%Q%%"  as PreQ9,
"10. What is your current employment status%%Q%% (One or more categories may be selected.)"  as PreQ10,
"11. How many years of experience do you have working for SCDSS%%Q%%"  as PreQ11,
"12. What is the title of your current position with SCDSS%%Q%%"  as PreQ12,
"13. Does your current position involve supervising other employees%%Q%% (Not interns.)"  as PreQ13,
"14. Are you a licensed foster parent%%Q%%"  as PreQ14,
"15. What is your total household income for the past 12 months%%Q%% (Before taxes, from all sources.)"  as PreQ15

--Filling in the completed answers for each user
UNION
SELECT userid,
       Substring_index(Substring_index(answers, ",", 1), ",", -1)  AS Pre1,
       Substring_index(Substring_index(answers, ",", 2), ",", -1)  AS Pre2,
       Substring_index(Substring_index(answers, ",", 3), ",", -1)  AS Pre3,
       Substring_index(Substring_index(answers, ",", 4), ",", -1)  AS Pre4,
       Substring_index(Substring_index(answers, ",", 5), ",", -1)  AS Pre5,
       Substring_index(Substring_index(answers, ",", 6), ",", -1)  AS Pre6,
       Substring_index(Substring_index(answers, ",", 7), ",", -1)  AS Pre7,
       Substring_index(Substring_index(answers, ",", 8), ",", -1)  AS Pre8,
       Substring_index(Substring_index(answers, ",", 9), ",", -1)  AS Pre9,
       Substring_index(Substring_index(answers, ",", 10), ",", -1) AS Pre10,
       Substring_index(Substring_index(answers, ",", 11), ",", -1) AS Pre11,
       Substring_index(Substring_index(answers, ",", 12), ",", -1) AS Pre12,
       Substring_index(Substring_index(answers, ",", 13), ",", -1) AS Pre13,
       Substring_index(Substring_index(answers, ",", 14), ",", -1) AS Pre14,
       Substring_index(Substring_index(answers, ",", 15), ",", -1) AS Pre15

/* Feedback answer values and other feedback information is seperated into two tables: {feedback_value} and {feedback_completed}
   These tables are joined and grouped by userid and relevant feedback activity
*/
FROM (
    SELECT userid,
               Cast(Group_concat(value) AS CHAR) AS answers --Groups all answers from one user into a single string
        FROM   {feedback_value} AS items
               JOIN {feedback_completed} AS cmpl
                 ON items.completed = cmpl.id
        WHERE  cmpl.feedback IN ( 3 ) -- Feedback ID 3 is the CAIP PRE course activity
        GROUP  BY userid
     ) AS x 