<% 
public function listCountry()
    dim rs, sql
    sql = "SELECT country_id, country_name, country_initials_alfa_2, country_active FROM t_country;"
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set listCountry = rs
end function

public function listCountryActive()
    dim rs, sql
    sql = "SELECT * FROM t_country WHERE country_active = 1"
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set listCountryActive = rs   
end function

public sub updateCountry(country_id , active)
    sql = "UPDATE t_country set country_active = " & active & " WHERE country_id = " & country_id 
    objConn.Execute(cstr(sql))
end sub

%>