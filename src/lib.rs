use pyo3::prelude::*;

/// Formats the sum of two numbers as string.
#[pyfunction]
fn sum_as_string(a: usize, b: usize) -> PyResult<String> {
    Ok((a + b).to_string())
}

/// Returns a greeting string.
#[pyfunction]
fn ayo() -> PyResult<String> {
    Ok("ayo from rust".to_string())
}

/// A Python module implemented in Rust.
#[pymodule(gil_used = false)]
fn _nodoka(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(sum_as_string, m)?)?;
    m.add_function(wrap_pyfunction!(ayo, m)?)?;
    Ok(())
}
