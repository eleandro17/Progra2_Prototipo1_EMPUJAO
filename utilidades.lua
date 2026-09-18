function clampCamara(cam, mapaAnchoPx, mapaAltoPx, viewW, viewH)
    local zoom = cam.scale or 1
    local viewWEfectivo = viewW / zoom
    local viewHEfectivo = viewH / zoom

    local x, y = cam.x, cam.y

    if mapaAnchoPx <= viewWEfectivo then
        x = mapaAnchoPx / 2
    else
        x = math.max(viewWEfectivo / 2, math.min(mapaAnchoPx - viewWEfectivo / 2, x))
    end

    if mapaAltoPx <= viewHEfectivo then
        y = mapaAltoPx / 2
    else
        y = math.max(viewHEfectivo / 2, math.min(mapaAltoPx - viewHEfectivo / 2, y))
    end

    cam:lookAt(x, y)
end

