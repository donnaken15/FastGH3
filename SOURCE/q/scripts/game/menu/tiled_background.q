
script TileSprite\{parent = root_window container_type = ContainerElement tile_dims = (1280.0, 720.0) Pos = (0.0, 0.0) sprite_props = {}container_props = {}}
	if NOT GotParam \{texture}
		printf \{'TileSprite needs a texture'}
		return
	endif
	CreateScreenElement {
		Type = <container_type>
		parent = <parent>
		dims = <tile_dims>
		Pos = <Pos>
		just = [left top]
		child_anchor = [left top]
		<container_props>
	}
	<container_id> = <id>
	if NOT GotParam \{dims}
		CreateScreenElement {
			Type = SpriteElement
			parent = <parent>
			texture = <texture>
		}
		GetScreenElementDims id = <id>
		if ((<width> < 1)|| (<height> < 1))
			printf \{'why is the width or height not positive?'}
			DestroyScreenElement id = <container_id>
			return
		endif
		DestroyScreenElement id = <id>
	else
		<width> = (<dims> [0])
		<height> = (<dims> [1])
	endif
	<container_id> ::SetTags {
		width = <width>
		height = <height>
		Pos = <Pos>
	}
	if GotParam \{flip_h}
		<container_id> ::SetTags {
			flip_h
		}
	endif
	if GotParam \{flip_v}
		<container_id> ::SetTags {
			flip_v
		}
	endif
	<X> = 0
	<y> = 0
	<row> = 0
	<column> = 0
	<count> = 0
	begin
		<Flip> = {}
		if GotParam \{flip_h}
			Mod a = <row> b = (2)
			if (<Mod> = 0)
				<Flip> = {flip_h}
			endif
		endif
		if GotParam \{flip_v}
			Mod a = <column> b = (2)
			if (<Mod> = 0)
				<Flip> = {<Flip> flip_v}
			endif
		endif
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_id>
			texture = <texture>
			dims = <dims>
			just = [left top]
			Pos = (((1.0, 0.0) * <X>)+ ((0.0, 1.0) * <y>))
			<sprite_props>
			<Flip>
		}
		<count> = (<count> + 1)
		<X> = (<X> + <width>)
		<column> = (<column> + 1)
		if (<X> > (<tile_dims> [0]))
			<X> = 0
			<y> = (<y> + <height>)
			<row> = (<row> + 1)
			<column> = 0
			if (<y> > (<tile_dims> [1]))
				return {id = <container_id> count = <count>}
			endif
		endif
	repeat
endscript

script TileSpriteLoop\{move_x = 1 move_y = 0}
	GetTags
	if GotParam \{flip_v}
		<width> = (<width> * 2)
	endif
	if GotParam \{flip_h}
		<height> = (<height> * 2)
	endif
	if ((<move_x> > <width>)|| (<move_x> < (<width> * -1)))
		printf \{'move_x is greater then the width of the image'}
		return
	endif
	if ((<move_y> > <height>)|| (<move_y> < (<height> * -1)))
		printf \{'move_y is greater then the height of the image'}
		return
	endif
	<X> = 0
	<y> = 0
	begin
		<X> = (<X> + <move_x>)
		<y> = (<y> + <move_y>)
		if (<X> > <width>)
			<X> = (<X> - <width>)
			DoMorph {
				Pos = {((-1.0, 0.0) * <width>)relative}
			}
		endif
		if (<X> < (<width> * -1))
			<X> = (<width> + <X>)
			DoMorph {
				Pos = {((1.0, 0.0) * <width>)relative}
			}
		endif
		if (<y> > <height>)
			<y> = (<y> - <height>)
			DoMorph {
				Pos = {((0.0, -1.0) * <height>)relative}
			}
		endif
		if (<y> < (<height> * -1))
			<y> = (<height> + <y>)
			DoMorph {
				Pos = {((0.0, 1.0) * <height>)relative}
			}
		endif
		DoMorph {
			Pos = (((1.0, 0.0) * ((<Pos> [0])+ <X>))+ ((0.0, 1.0) * ((<Pos> [1])+ <y>)))
			time = 0.1
		}
	repeat
endscript
