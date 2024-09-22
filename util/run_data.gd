extends Node
enum Season {
	WINTER,
	SUMMER,
	SPRING,
	FALL
}
var season:Season;
var money:int = 10000;
var days_survived:int = 0;
func reset():
	money = 0;
	pass;
