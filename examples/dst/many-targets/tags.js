define(['dust-runtime'], function () {
	// src/tags.dust
	(function(){dust.register("src/tags.dust",body_0);function body_0(chk,ctx){return chk.exists(ctx.get("tags"),ctx,{"else":body_1,"block":body_2},null);}function body_1(chk,ctx){return chk.write("No Tags!");}function body_2(chk,ctx){return chk.write("<ul>").section(ctx.get("tags"),ctx,{"block":body_3},null).write("</ul>");}function body_3(chk,ctx){return chk.write("<li>").reference(ctx.getPath(true,[]),ctx,"h").write("</li>");}return body_0;})();
});