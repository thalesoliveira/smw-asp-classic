<% 
public function listTeam()
    dim rs, sql
    sql = "SELECT t_team.*, t_country.country_name, t_country.country_initials_alfa_2 FROM t_team LEFT JOIN t_country ON t_country.country_id = t_team.country_id;"
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set listTeam = rs
end function

public function findUser(user_id)
    dim rs, sql
    sql = "SELECT * FROM t_user WHERE user_id = " & user_id
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn   
    Set findUser = rs
end function

public function findTeamInfo(user_id)
    dim rs, sql
    sql = "SELECT "
    sql = sql & " t_team.team_name, t_team.team_description, t_team.team_founded_year, t_team.address_id, t_team.contact_id, "
    sql = sql & " t_coach.coach_id, t_coach.coach_name, "
    sql = sql & " t_country.country_id, t_country.country_name,  "
    sql = sql & " t_address.address_id, t_address.address_name, t_address.address_city, t_address.address_street, t_address.address_postal_code, "
    sql = sql & " t_contact.contact_id, t_contact.contact_email, t_contact.contact_website, "
    sql = sql & " t_phone.phone_id ,t_phone.phone_ddi, t_phone.phone_number "

    sql = sql & " FROM t_team "

    sql = sql & " LEFT JOIN t_country ON t_country.country_id = t_team.country_id "
    sql = sql & " LEFT JOIN t_coach ON t_coach.coach_id = t_team.coach_id "    
    sql = sql & " LEFT JOIN t_address ON t_address.address_id = t_team.address_id "
    sql = sql & " LEFT JOIN t_contact ON t_contact.contact_id = t_team.contact_id "
    sql = sql & " LEFT JOIN t_phone_team ON t_phone_team.team_id = t_team.team_id "
    sql = sql & " LEFT JOIN t_phone ON t_phone_team.phone_id= t_phone_team.phone_id "

       
    Set rs = objConn.Execute(sql)
    Set findTeamInfo = rs
end function

public sub removeTeam(user_id)    
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