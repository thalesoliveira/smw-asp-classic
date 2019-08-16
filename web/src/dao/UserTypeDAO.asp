<% 
public function listTypeUser()
    dim rs, sql
    sql = "SELECT * FROM t_type_user"

    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn

    if rs.EOF And rs.BOF Then
        Set listTypeUser = Null
    else
        Set listTypeUser = rs
    end if
        
end function

public function findTypeUser(id)
    dim rs, sql
    
    sql = "SELECT * FROM t_type_user WHERE type_user_id = " & id
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn

    If rs.EOF And rs.BOF Then
        Set findTypeUser = Null        
    Else
        Set findTypeUser = rs        
    End If
    
end function

public sub removeTypeUser(id)
    sql = "DELETE t_type_user WHERE type_user_id = " & id
    objConn.Execute(cstr(sql))
end sub

public sub insertTypeUser(type_user_description , type_user_active)
    sql = "INSERT INTO t_type_user (type_user_description, type_user_active) VALUES ('" & type_user_description & "'," & type_user_active & ")"
    objConn.Execute(cstr(sql))
end sub

public sub updateTypeUser(id, type_user_description, type_user_active)
    sql = "UPDATE t_type_user SET type_user_description = '" & type_user_description & "', type_user_active = " & type_user_active & " WHERE type_user_id = " & id
    objConn.Execute(cstr(sql))
end sub

%>