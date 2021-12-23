###############################################################
-- Pie-in-the-Sky (Mini Project)
--     IPL Match Bidding App
###############################################################

use ipl;

-- Show the percentage of wins of each bidder in the order of highest to lowest percentage.
###################################################################################################
	select bidder_id, sum(total_points)/sum(no_of_matches)*100 as Winning_Percentage
	from IPL_Bidder_Points
	group by bidder_id
	order by Winning_Percentage desc;

-- Display the number of matches conducted at each stadium with stadium name, city from the database.
###################################################################################################
	select s.stadium_name, s.city, count(*) as"Number of matches"
	from IPL_Match_Schedule ms join IPL_stadium s
    on ms.stadium_id = s.stadium_id
    group by s.stadium_name, s.city;
    
-- In a given stadium, what is the percentage of wins by a team which has won the toss?
###################################################################################################
    select team.team_name,s.stadium_name,(ts.matches_won/ts.matches_played)*100 as "Win Percentage"
    from IPL_Match m 
		join IPL_Match_Schedule ms
			on m.match_id = ms.match_id
		join IPL_Team_Standings ts
			on ts.tournmt_id = ms.tournmt_id
		join IPL_Team team
			on team.team_id = ts.team_id
		join IPL_stadium s
			on ms.stadium_id = s.stadium_id
    where m.toss_winner = m.match_winner
    group by team.team_name,s.stadium_name;
    
-- Show the total bids along with bid team and team name.   
###################################################################################################
	select bid_team,team_name,sum(bid_points.NO_OF_BIDS) as "Total Bids"
    from IPL_Bidding_Details bid_details
		join IPL_Team team
			on bid_details.bid_team = team.team_id
		join ipl_bidder_points bid_points
			on bid_details.BIDDER_ID = bid_points.BIDDER_ID
	group by bid_team,team_name
    order by bid_team;

-- Show the team id who won the match as per the win details
###################################################################################################
	select case
			when team_id1 = match_winner 
				then team_id1 
				else team_id2
		   end as "Team ID as per Win Details", win_details
    from IPL_Match;
    
-- Display total matches played, total matches won and total matches lost by team along with its team name
###################################################################################################
	-- Since not mentioned for which year the points table is to be displayed. Have added the tournament_id for better clearance in the result.
    select standings.tournmt_id as "Year",
			team.team_name as "Team Name",
			standings.matches_played as "Matches Played",
			standings.matches_won as "Matches Won",
            standings.matches_lost as "Matches Lost"
    from  IPL_Team team join IPL_Team_Standings standings
		on  team.team_id = standings.team_id;
    
-- Display the bowlers for Mumbai Indians team
###################################################################################################
	select player.player_name,team_players.remarks,team_players.player_role
    from IPL_Team_players team_players join IPL_player player
		on team_players.PLAYER_ID = player.PLAYER_ID
	where team_players.remarks like '%MI' and team_players.player_role like 'Bowler';
    
-- How many all-rounders are there in each team, Display the teams with more than 4 all-rounder in descending order.
###################################################################################################
	select team.team_name,count(*) as "No_of_All_Rounder"
    from IPL_Team_players team_players 
    join IPL_Team team
		on team_players.team_id = team.team_id
	where team_players.player_role like 'All-Rounder'
    group by team.team_name
    having count(*)>4;