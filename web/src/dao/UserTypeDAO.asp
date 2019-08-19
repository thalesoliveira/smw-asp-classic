<% 
public function listTypeUser()
    dim rs, sql
    sql = "SELECT * FROM t_type_user"

    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set listTypeUser = rs           
end function

public function findTypeUser(type_user_id)
    dim rs, sql    
    sql = "SELECT * FROM t_type_user WHERE type_user_id = " & type_user_id
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set findTypeUser = rs
end function

public function listTypeUserActive()
    dim rs, sql
    sql = "SELECT * FROM t_type_user WHERE type_user_active = 1"
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set listTypeUserActive = rs   
end function

public sub removeTypeUser(type_user_id)
    dim sql
    sql = "DELETE t_type_user WHERE type_user_id = " & type_user_id
    objConn.Execute(cstr(sql))
end sub

public sub insertTypeUser(type_user_description , type_user_active)
    dim sql
    sql = "INSERT INTO t_type_user (type_user_description, type_user_active) VALUES ('" & type_user_description & "'," & type_user_active & ")"
    objConn.Execute(cstr(sql))
end sub

public sub updateTypeUser(type_user_id, type_user_description, type_user_active)
    dim sql
    sql = "UPDATE t_type_user SET type_user_description = '" & type_user_description & "', type_user_active = " & type_user_active & " WHERE type_user_id = " & type_user_id
    objConn.Execute(cstr(sql))
end sub

%>