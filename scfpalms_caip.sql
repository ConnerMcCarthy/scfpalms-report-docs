/* Selects information from users that have completed the CAIP course and recieved a certificate in the last week */

--Each row contains a user and personal info as columns
SELECT    profile.role AS "Role",
          users.firstname "First Name",
          users.lastname "Last Name",
          profile.licensingagency                                              AS "Licensing Agency",
          profile.licensenumber                                                AS "License Number",
          profile.phone                                                        AS "Phone Number",
          users.email                                                          AS "Email Address",
          profile.homeaddress                                                  AS "Home Address",
          profile.cityandstate                                                 AS "City, State",
          profile.county                                                       AS "County",
          profile.zipcode                                                      AS "ZIP Code",
          Date_format(From_unixtime(cert.timecreated), '%Y-%m-%d %H:%i:%s') AS "Certificate Awarded" -- Date 
FROM      {user}                                                         AS users

--Joins the custom profile field table. Groups by moodle user ID.
LEFT JOIN
          (
                   --Empty columns are fixed and grouped
                   SELECT   userid,
                            group_concat(role separator "")            AS "Role",
                            group_concat(homeaddress separator "")     AS "HomeAddress",
                            group_concat(cityandstate separator "")    AS "CityandState",
                            group_concat(county separator "")          AS "County",
                            group_concat(zipcode separator "")         AS "ZIPCode",
                            group_concat(licensingagency separator "") AS "LicensingAgency",
                            group_concat(licensenumber separator "")   AS "LicenseNumber",
                            group_concat(phone separator "")           AS "Phone"
                   FROM     (
                                            --Selects from the users profile fields. 
                                            SELECT DISTINCT userid,
                                                            IF(fieldid=11, data, "") as 'HomeAddress',
                                                            IF(fieldid=6, data, "")  AS 'CityandState',
                                                            IF(fieldid=3, data, "")  AS 'County',
                                                            IF(fieldid=8, data, "")  AS 'ZIPCode',
                                                            IF(fieldid=7, data, "")  AS 'Phone',
                                                            IF(fieldid=4, data, "")  AS 'Role',
                                                            IF(fieldid=5, data, "")  AS 'LicensingAgency',
                                                            IF(fieldid=10, data, "") AS 'LicenseNumber'
                                            FROM            {user_info_data} AS fields_split
                            ) AS fields GROUP BY fields.userid 
            ) AS profile
ON        profile.userid = users.id

-- Joins certificate information for the user
LEFT JOIN {customcert_issues} AS cert
ON        cert.userid = users.id

WHERE     cert.customcertid = 38 -- Certificate ID 38 is the CAIP course
AND       cert.timecreated IS NOT NULL -- Selects ONLY completed certificates
AND       cert.userid NOT IN (5499, 5) -- User IDs 5 and 5499 are admins and removed
AND       date_format(from_unixtime(cert.timecreated), '%Y-%m-%d') >= cast( now() AS date ) - interval 1 week -- Selects ONLY certificates completed the previous week