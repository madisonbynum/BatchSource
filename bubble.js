function bubble(event) {
    event.stopPropagation();
    let element = event.currentTarget;
    element.style.backgroundColor = "green";
    alert(element.id);
    event.stopPropagation;
}

window.onload = function() {
    document.getElementById("A").addEventListener("click",bubble,false);
    document.getElementById("B").addEventListener("click",function(){ bubble(this);},false);
    document.getElementById("C").addEventListener("click",function(){ bubble(this);},false);
    document.getElementById("D").addEventListener("click",bubble,false);
}