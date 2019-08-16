<% 
public function listState()
    dim rs, sql
    sql = "SELECT tc.country_name, tc.country_initials_alfa_2, ts.state_name, ts.state_initials,  ts.state_id FROM t_state ts "
    sql = sql & " INNER JOIN t_country tc ON tc.country_id = ts.country_id  ;"

    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn

    if rs.EOF And rs.BOF Then
        Set listState = Null
    else
        Set listState = rs
    end if
        
end function

public function findState(id)
    dim rs, sql
    
    sql = "SELECT * FROM t_state WHERE state_id = " & id
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn

    If rs.EOF And rs.BOF Then
        Set findState = Null        
    Else
        Set findState = rs        
    End If

end function

public sub removeState(id)
    sql = "DELETE t_state WHERE state_id  = " & id
    objConn.Execute(cstr(sql))
end sub

public sub insertState(state_name, state_initials, country_id)
    sql = "INSERT INTO t_state (state_name, state_initials, country_id) VALUES ('" & state_name & "','" & state_initials & "'," & country_id & ")"
    objConn.Execute(cstr(sql))
end sub

public sub updatePositionPlayer(id, state_name, state_initials, country_id)
    sql = "UPDATE t_state set state_name = '" & state_name & "', state_initials = '" & state_initials & "', country_id = '" & country_id & "' WHERE state_id = " & id	           
    objConn.Execute(cstr(sql))
end sub

%>