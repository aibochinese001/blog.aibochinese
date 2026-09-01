export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    let path = url.pathname;
    if (path === "/") path = "/index.html";
    if (path === "/404") path = "/404.html";

    let res = await env.ASSETS.fetch(new URL(path, request.url), request);
    if (res.status === 404 && path !== "/404.html") {
      res = await env.ASSETS.fetch(new URL("/404.html", request.url), request);
    }
    return res;
  },
};
