<% 
public function listState()
    dim rs, sql
    sql = "SELECT tc.country_name, tc.country_initials_alfa_2, ts.state_name, ts.state_initials,  ts.state_id FROM t_state ts "
    sql = sql & " INNER JOIN t_country tc ON tc.country_id = ts.country_id  ;"

    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set listState = rs 

end function

public function findState(state_id)
    dim rs, sql
    
    sql = "SELECT * FROM t_state WHERE state_id = " & state_id
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set findState = rs
 
end function

public function findStateFromCountry(country_id)
    dim rs, sql
    
    sql = "SELECT state_id, state_name FROM t_state WHERE country_id = " & country_id
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set findStateFromCountry = rs
 
end function


public sub removeState(state_id)
    sql = "DELETE t_state WHERE state_id  = " & state_id
    objConn.Execute(cstr(sql))
end sub

public sub insertState(state_name, state_initials, country_id)
    sql = "INSERT INTO t_state (state_name, state_initials, country_id) VALUES ('" & state_name & "','" & state_initials & "'," & country_id & ")"
    objConn.Execute(cstr(sql))
end sub

public sub updatePositionPlayer(state_id, state_name, state_initials, country_id)
    sql = "UPDATE t_state set state_name = '" & state_name & "', state_initials = '" & state_initials & "', country_id = '" & country_id & "' WHERE state_id = " & state_id
    objConn.Execute(cstr(sql))
end sub

%>