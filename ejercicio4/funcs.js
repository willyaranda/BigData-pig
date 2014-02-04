CountProducts.outputSchema = "num:long";

function CountProducts(json) {
    return JSON.parse(json).products.length;
}