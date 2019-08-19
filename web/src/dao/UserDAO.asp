<% 
public function listUser()
    dim rs, sql
    sql = "SELECT t_user.user_id, user_first_name, type_user_description FROM t_user LEFT JOIN t_type_user ON t_type_user.type_user_id = t_user.type_user_id"
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set listUser = rs        
end function

public function findUser(user_id)
    dim rs, sql
    sql = "SELECT * FROM t_user WHERE user_id = " & user_id
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn   
    Set findUser = rs
end function

public function findUserInfo(user_id)
    dim rs, sql
    sql = "SELECT t_user.*, t_type_user.type_user_description, t_country.country_name, t_state.state_name FROM t_user" 
    sql = sql & " LEFT JOIN t_type_user ON t_type_user.type_user_id = t_user.type_user_id "
    sql = sql & " LEFT JOIN t_country ON t_country.country_id = t_user.country_id "
    sql = sql & " LEFT JOIN t_state ON t_state.state_id = t_user.state_id "
    sql = sql & " WHERE user_id = " & user_id

    Set rs = objConn.Execute(sql)
    Set findUserInfo = rs
end function

public sub removeUser(user_id)    
    sql = "DELETE t_user WHERE user_id = " & user_id
    objConn.Execute(cstr(sql))
end sub

public sub insertUser(user_first_name, user_last_name, type_user_id, country_id, state_id, user_login, user_password)
    sql = "INSERT INTO t_user (user_first_name, user_last_name, type_user_id, country_id, state_id, user_login, user_password) VALUES ('" & user_first_name & "','" & user_last_name & "'," & user_id_type & "," & id_country & "," & id_state & ",'" & user_login & "','" & user_password & "')"
    objConn.Execute(cstr(sql))
end sub

public sub updateUser(user_id, user_first_name, user_last_name, user_type_id, country_id, state_id, user_login, user_password)

    if state_id = "" then state_id = 0

    sql = " UPDATE t_user "
    sql = sql & " SET user_first_name= '" & user_first_name & "', user_last_name = '" & user_last_name & "', type_user_id = '" & user_type_id & "'"
    sql = sql & " ,country_id = " &  country_id & ", user_login = '" &  user_login & "', state_id = " & state_id
    sql = sql & " WHERE user_id = " & user_id

    objConn.Execute(cstr(sql))
end sub

public sub updateUserPassword(user_id, user_password)
    sql = "UPDATE t_user set user_password  = '" & user_password  & "'" & " WHERE user_id = " & user_id
    objConn.Execute(cstr(sql))
end sub

%>