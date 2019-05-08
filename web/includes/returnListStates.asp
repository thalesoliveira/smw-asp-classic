
<!-- #include virtual="/config/conexao.asp" --> 
<%

Function returnListStates()
    sql = "SELECT country, initials_alfa_2, active FROM t_country;"
    Set rs = objConn.Execute(sql)
    returnListStates=rs
End Function