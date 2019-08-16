<% 
public function listPositionPlayer()
    dim rs, sql
    sql = "SELECT * FROM t_position_player"

    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn

    If rs.EOF And rs.BOF Then
        Set listPositionPlayer = Null        
    Else
        Set listPositionPlayer = rs        
    End If

end function

public function findPositionPlayer(id)
    dim rs, sql
    sql = "SELECT * FROM t_position_player WHERE position_player_id  = " & id
    
    set rs=Server.CreateObject("ADODB.recordset")
    rs.Open sql, objConn

    If rs.EOF And rs.BOF Then
        Set findPositionPlayer = Null        
    Else
        Set findPositionPlayer = rs        
    End If

end function

public sub removePositionPlayer(id)    
    sql = "DELETE t_position_player WHERE position_player_id  = " & id
    objConn.Execute(cstr(sql))
end sub

public sub insertPositionPlayer(position_player_name)
    sql = "INSERT INTO t_position_player (position_player_name) VALUES ('" & position_player_name & "')"
    objConn.Execute(cstr(sql))
end sub

public sub updatePositionPlayer(id, position_player_name)
    sql = "UPDATE t_position_player SET position_player_name = '" & position_player_name &  "' WHERE position_player_id = " & id        
    objConn.Execute(cstr(sql))
end sub

%>