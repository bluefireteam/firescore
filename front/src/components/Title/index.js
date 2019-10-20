import React from "react"
import "./index.css"

const component = ({ children }) => {
    return (<h1 className="title">{children}</h1>)
}

export default component