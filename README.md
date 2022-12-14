# SCFPALMS SQL reports
Documentation and code for weekly reports and admin tools are included in this repository. Additional info below.

**Reports**
- Orientation Weekly - www.scfpalms.com/report/customsql/view.php?id=16
- CAIP Weekly - www.scfpalms.com/report/customsql/view.php?id=1
- HCOPT Weekly - www.scfpalms.com/report/customsql/view.php?id=8
- CAIP Pre Feedback - www.scfpalms.com/report/customsql/view.php?id=11

**Admin Tools**
- Check Certificate IDs - www.scfpalms.com/report/customsql/view.php?id=7
- All Users w/ Filter - www.scfpalms.com/report/customsql/edit.php?id=9

---
#Maintanence
## Moodle SQL Information
- Plugin documentation at www.moodle.org/plugins/report_customsql
- List of tables and column names in the SCFPALMS database can be found at www.scfpalms.com/report/customsql/view.php?id=19
- The SQL plugin used requires removing the "mdl_" prefix from tables names. So mdl_user becomes {user} 

Commonly used tables: 
- {user} - User info
- {user_info_data} - Custom profile field info
- {customcert_issues} - List of completed certificates

## Creating Weekly Reports
1. Copy SQL code from the CAIP weekly report at www.scfpalms.com/report/customsql/edit.php?id=1
2. Go to www.scfpalms.com/report/customsql/index.php and click the "Add a new query" button
3. Enter catagory, query name, and paste the code in the "Query SQL" box

4. Run the "Check Certificate ID" report at www.scfpalms.com/report/customsql/view.php?id=7
5. At the bottom of the SQL code, edit "WHERE a.customcertid = 38" with the relevant certificate code
6. Edit the Run and Email options then save changes.


