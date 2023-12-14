extends Node2D

var furnitureResource = preload("res://Save/Furniture/furnitureSave.tres")



func _on_button_pressed():
	for i in range (0, furnitureResource.furnitureList.size() -1):
		furnitureResource.furnitureList[i].countF = 0
		furnitureResource.furnitureList[i].active = false
		furnitureResource.furnitureList[i].posF.clear()
		furnitureResource.furnitureList[i].roomF.clear()
		furnitureResource.furnitureList[i].instanceID.clear()
		furnitureResource.furnitureList[i].furnitureInScene.clear()
		furnitureResource.furnitureList[i].furnitureInScene.resize(9)
		furnitureResource.furnitureList[i].furnitureInScene.fill(0)
		furnitureResource.furnitureList[i].counterF = 0
	save()
	
func save():
	ResourceSaver.save(furnitureResource, "res://Save/Furniture/furnitureSave.tres")
