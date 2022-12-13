/* 
  Selects information from EVERY user that has completed the CAIP course and recieved a certificate.
  Uses a custom time, course, and name filter.

  The ":" character is used with the custom moodle sql plugin. It specifies a user input variable shown before running the query. 
*/

--Each row contains a user with personal info as columns
SELECT     course.NAME AS "Course",
           users.firstname "First Name",
           users.lastname "Last Name",
           profile.role                                                AS "Role",
           profile.licensingagency                                     AS "Licensing Agency",
           profile.phone                                               AS "Phone Number",
           users.email                                               AS "Email Address",
           profile.cityandstate                                        AS "City, State",
           Date_format(From_unixtime(cert.timecreated), '%Y-%m-%d') AS "Date Awarded"
FROM       {user}                                                AS users
--Joins the custom profile field table. Groups by moodle user ID.
LEFT JOIN
           (
                    --Empty columns are fixed and grouped
                    SELECT   userid,
                             group_concat(role separator "")            AS "Role",
                             group_concat(homeaddress separator "")     AS "HomeAddress",
                             group_concat(cityandstate separator "")    AS "Cityandstate",
                             group_concat(county separator "")          AS "County",
                             group_concat(zipcode separator "")         AS "ZIPCode",
                             group_concat(licensingagency separator "") AS "LicensingAgency",
                             group_concat(phone separator "")           AS "Phone"
                    FROM     (
                                             --Selects from the users profile fields. 
                                             SELECT DISTINCT userid,
                                                             IF(fieldid=11, data, "") as 'HomeAddress',
                                                             IF(fieldid=6, data, "")  AS 'Cityandstate',
                                                             IF(fieldid=3, data, "")  AS 'County',
                                                             IF(fieldid=8, data, "")  AS 'ZIPCode',
                                                             IF(fieldid=7, data, "")  AS 'Phone',
                                                             IF(fieldid=4, data, "")  AS 'Role',
                                                             IF(fieldid=5, data, "")  AS 'LicensingAgency'
                                             FROM            {user_info_data} as fields_split
                             ) AS fields GROUP BY fields.userid 
                    ) AS profile
ON         profile.userid = users.id

-- Joins certificate information for the user
LEFT JOIN  {customcert_issues} AS cert
ON         cert.userid = users.id
-- Joins course information
INNER JOIN {customcert} AS course
ON         cert.customcertid = course.id

WHERE      cert.timecreated IS NOT NULL
AND        cert.userid NOT IN (5499) --remove admin user
AND        cert.timecreated > :after_this_date --date before and after filter
AND        cert.timecreated < :before_this_date
AND        course.NAME LIKE concat( concat('%', :course ), '%' ) --course filter
AND        concat(concat(concat(users.firstname," "), users.lastname),users.email) LIKE concat( concat('%', :name), '%' ) --name filter
ORDER BY   cert.timecreated DESC
