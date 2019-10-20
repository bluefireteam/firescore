import React from "react"
import "./index.css"

const component = ({ children }) => {
    return (<label className="label">{children}</label>)
}

export default component