# Created by Micah
# Work in Progress

  def getTarget(index)
    targetIndex = rand($Trainer.pokemon_count - 1)
    return index == targetIndex ? targetIndex + 1 : targetIndex
  end
    
    # TODO 
  def chase(index, target)
    return if $chasers.include?(index)
    #pbMessage(_INTL("Pokemon is chasing! {1}", $game_map.events[index].name))
    $chasers.push(index)
    $targets.push(target)
    PathFinder.dyn_find(index, target)
  end
    
    
    
    # TODO
  def takeNap(pkmn)
    #pbMessage(_INTL("Pokemon is napping! {1}", pkmn.name))
    pbOverworldAnimation(pkmn, FollowingPkmn::ANIMATION_EMOTE_ELIPSES)
  end
    
    # TODO
  def bond(pokemon, friend)
    
  end
    
    # TODO
  def showHunger(pkmn)
    #pbMessage(_INTL("Pokemon is wanting food! {1}", pkmn.name))
    pbOverworldAnimation(pkmn, FollowingPkmn::ANIMATION_EMOTE_ELIPSES)
  end
  
  def toggleOnPokemonBehavior
    $chasers = []
    $targets = []
    EventHandlers.add(:on_frame_update, :pokemonBehavior,
        proc {
        if Camping.noInteraction?
          # Chasing handler
          if $chasers.size != 0
            for i in 0 ... $chasers.size
              if pbEventCanReachPlayer?($game_map.events[$chasers[i]], $game_map.events[$targets[i]], 1)
                chaser = $chasers[i]
    
                $chasers.delete_at(i)
                $targets.delete_at(i)
                
                $game_map.events[chaser].clear_path_target
                
                pbOverworldAnimation($game_map.events[chaser], 
                FollowingPkmn::ANIMATION_EMOTE_HEART)
                
                pbMoveRoute($game_map.events[chaser], [
                PBMoveRoute::Jump,0,0,
                PBMoveRoute::Jump,0,0,
                PBMoveRoute::Backward,
                PBMoveRoute::TurnRightOrLeft90
                ])
              end
            end
          end
          
        
        
          # Range generated by rateOfEvents * Max Pokemon in Party
          # At the moment 1/1000 * 6
          rand = rand(600)
          if rand % 100 == 0
            index = rand / 100
            if $Trainer.pokemon_count > index
              pkmn = $game_map.events[index+1]
              case rand(3)
              when 0
                if $Trainer.pokemon_count > 1
                  chase(index + 1, getTarget(index)+1)
                end
              when 1
                takeNap(pkmn)
              when 2
                showHunger(pkmn)
              end
            end
          end
        end
    })
  end
  
  def toggleOffPokemonBehavior
     EventHandlers.remove(:on_frame_update, :pokemonBehavior)
  end
