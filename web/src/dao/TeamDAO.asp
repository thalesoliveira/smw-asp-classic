<% 
public function listTeam()
    dim rs, sql
    sql = "SELECT t_team.*, t_country.country_name, t_country.country_initials_alfa_2 FROM t_team LEFT JOIN t_country ON t_country.country_id = t_team.country_id;"
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set listTeam = rs
end function

public function findTeamInfo(team_id)
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
    sql = sql & " WHERE t_team.team_id = " & team_id

    Set rs = objConn.Execute(sql)
    Set findTeamInfo = rs
end function

public sub removeTeam(team_id)
    dim sql, rs    
    
    Set rs = objConn.Execute("SELECT address_id, contact_id, phone_id FROM t_team LEFT JOIN t_phone_team ON t_phone_team.team_id = t_team.team_id WHERE t_team.team_id = " & team_id)
    
    if not rs.EOF then
        address_id = rs("address_id")
        contact_id = rs("contact_id")
        phone_id = rs("phone_id")
    end if   
    
    sql = "DELETE t_team WHERE team_id = " & team_id
    objConn.Execute(cstr(sql))
    
    if address_id <> "" then objConn.Execute("DELETE t_address WHERE address_id = " & address_id)
    if contact_id <> "" then objConn.Execute("DELETE t_contact WHERE contact_id = " & contact_id)
                
    if phone_id <> "" then 
        objConn.Execute("DELETE t_phone_team WHERE team_id = " & id)
        objConn.Execute("DELETE t_phone WHERE phone_id = " & phone_id)
    end if

end sub

public sub insertTeam(team_name, team_description, country_id, coach_id, team_founded_year, address_name, address_city, address_street, address_postal_code, contact_email, contact_website, phone_ddi, phone_number)
    dim sql
    sql = "INSERT INTO t_team (team_name, team_description, country_id, coach_id, team_founded_year) VALUES ('" & team_name & "','" & team_description & "'," & id_country & "," & id_coach & ",'" & team_founded_year & "')"
    objConn.Execute(sql)

    Set rs = objConn.Execute("SELECT max(team_id) as id_insert FROM t_team")
    if not rs.EOF then id_insert = rs("id_insert")

    if address_name <> "" or address_city <> "" or address_street <> "" or address_postal_code <> "" then              
        sql = "INSERT INTO  t_address (address_name, address_city, address_street, address_postal_code) VALUES ('" & address_name & "','" & address_city & "','" & address_street & "','" & address_postal_code & "')"
        objConn.Execute(sql)

        sql = "SELECT max(address_id) as max_address FROM t_address"
        Set rs = objConn.Execute(sql)
        if rs("max_address") > 0 then                
            max_address = rs("max_address")              
        else
            max_address = 1
        end if
                
        sql = "UPDATE t_team set address_id = " & max_address & " WHERE team_id = " & id_insert
        objConn.Execute(sql)

    end if

    if contact_email  <> "" or contact_website <> "" then
        sql = "INSERT INTO t_contact (contact_email, contact_website) VALUES ('" & contact_email& "','" & contact_website & "')"
        objConn.Execute(sql)

        sql = "SELECT max(contact_id) as max_contact FROM t_contact"
        Set rs = objConn.Execute(sql)
        if rs("max_contact") > 0 then              
            max_contact = rs("max_contact")
        else
            max_contact = 1
        end if

        sql = "UPDATE t_team set contact_id = " & max_contact & " WHERE team_id = " & id_insert
        objConn.Execute(sql)

    end if

    if phone_ddi  <> "" or phone_number <> "" then
        sql = "INSERT INTO t_phone (phone_ddi, phone_number) VALUES ('" & phone_ddi & "','" & phone_number & "')"
                objConn.Execute(sql)
                
        sql = "SELECT max(phone_id) as max_phone FROM t_phone"
        Set rs = objConn.Execute(sql)

        if rs("max_phone") > 0 then
            max_phone = rs("max_phone")
        else
            max_phone = 1
        end if

        sql = "INSERT INTO t_phone_team (phone_id, team_id) VALUES (" & max_phone & "," & id_insert & ")"
        objConn.Execute(sql)

    end if    
end sub

public sub updateTeam(team_id, team_name, team_description, id_country, country_id, id_coach, team_founded_year, address_id, address_name, address_city, address_street,address_postal_code, contact_id, contact_email, contact_website, phone_ddi, phone_number)
    dim sql
    sql = "UPDATE t_team SET team_name='" & team_name & "', team_description='" & team_description & "', country_id = " & id_country & ", coach_id =" & id_coach & ",team_founded_year ='" & team_founded_year & "'" & " WHERE team_id = " & team_id
    objConn.Execute(sql)

    if address_id then
        sql = "UPDATE t_address SET address_name='" & address_name & "', address_city='" & address_city & "', address_street = '" & address_street & "', address_postal_code ='" & address_postal_code & "' WHERE address_id = " & address_id
        objConn.Execute(sql)
    end if

    if contact_id then
        sql = "UPDATE t_contact SET contact_email='" & contact_email & "', contact_website='" & contact_website & "' WHERE contact_id = " & contact_id        
        objConn.Execute(sql)
    end if

    Set rs = objConn.Execute("SELECT phone_id FROM t_phone_team WHERE team_id = " & team_id )
    if not rs.EOF then phone_id = rs("phone_id")

    if phone_id then
        sql = "UPDATE t_phone SET phone_ddi = '" & phone_ddi  &"' , phone_number = '" & phone_number & "' WHERE phone_id = " & phone_id        
        objConn.Execute(sql)
    end if
        
end sub


%>