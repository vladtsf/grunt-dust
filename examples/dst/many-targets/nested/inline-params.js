define(['dust-runtime'], function () {
	// src/nested/inline-params.dust
	(function(){dust.register("src/nested/inline-params.dust",body_0);function body_0(chk,ctx){return chk.section(ctx.get("profile"),ctx,{"block":body_1},{"bar":"baz","bing":"bong"});}function body_1(chk,ctx){return chk.reference(ctx.get("name"),ctx,"h").write(", ").reference(ctx.get("bar"),ctx,"h").write(", ").reference(ctx.get("bing"),ctx,"h");}return body_0;})();
});