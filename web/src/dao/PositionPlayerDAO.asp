<% 
public function listPositionPlayer()
    dim rs, sql
    sql = "SELECT * FROM t_position_player"

    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set listPositionPlayer = rs        

end function

public function findPositionPlayer(position_player_id)
    dim rs, sql
    sql = "SELECT * FROM t_position_player WHERE position_player_id  = " & position_player_id
    
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn
    Set findPositionPlayer = rs

end function

public sub removePositionPlayer(position_player_id)
    sql = "DELETE t_position_player WHERE position_player_id  = " & position_player_id
    objConn.Execute(cstr(sql))
end sub

public sub insertPositionPlayer(position_player_name)
    sql = "INSERT INTO t_position_player (position_player_name) VALUES ('" & position_player_name & "')"
    objConn.Execute(cstr(sql))
end sub

public sub updatePositionPlayer(position_player_id, position_player_name)
    sql = "UPDATE t_position_player SET position_player_name = '" & position_player_name &  "' WHERE position_player_id = " & position_player_id
    objConn.Execute(cstr(sql))
end sub

%>