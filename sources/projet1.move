module gab::Gab;

use std::string::{String, utf8};
use sui::display;
use sui::object::new;
use sui::package;
use sui::url;

public struct Gab has key, store {
    id: UID,
    name: String,
    description: String,
    image_url: url::Url,
    creator: address,
}

public struct GAB has drop {}

fun init(otw: GAB, ctx: &mut TxContext) {
    let publisher = package::claim(otw, ctx);
    let mut display = display::new<Gab>(&publisher, ctx);

    display.add(
        b"name".to_string(),
        b"{name}".to_string(),
    );

    display.add(
        b"description".to_string(),
        b"{description}".to_string(),
    );
    display.add(
        b"image_url".to_string(),
        b"{image_url}".to_string(),
    );
    display.add(
        b"creator".to_string(),
        b"{creator}".to_string(),
    );

    display.update_version();

    transfer::public_transfer(publisher, ctx.sender());
    transfer::public_transfer(display, ctx.sender())
}

public entry fun mint(
    name: vector<u8>,
    description: vector<u8>,
    image_url: vector<u8>,
    ctx: &mut TxContext,
) {
    let sender = ctx.sender();
    let gab = Gab {
        id: new(ctx),
        name: utf8(name),
        description: utf8(description),
        image_url: url::new_unsafe_from_bytes(image_url),
        creator: sender,
    };
    transfer::public_transfer(gab, sender)
}
