<%


connString = "PROVIDER=SQLOLEDB;DATA SOURCE=mssql01.inter.net.br;UID=nomedousuariodobanco;PWD=suasenha;DATABASE=nomedobancoaqui"

set objConn = Server.CreateObject("ADODB.Connection")
objConn.open = connString

%>