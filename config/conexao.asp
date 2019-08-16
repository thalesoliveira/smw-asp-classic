<%
connString = "Provider=SQLOLEDB.1; Data Source=localhost; Initial Catalog=ldp; User ID=usr_ldp; Password=Abcd1234!!;"
set objConn = Server.CreateObject("ADODB.Connection")
objConn.open connString

%>
