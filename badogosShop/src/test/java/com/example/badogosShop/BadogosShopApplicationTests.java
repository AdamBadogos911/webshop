package com.example.badogosShop;

import com.example.badogosShop.config.email.EmailSender;
import com.example.badogosShop.dto.ProductDto;
import com.example.badogosShop.dto.UserUpdate;
import com.example.badogosShop.entity.*;
import com.example.badogosShop.repository.*;
import com.example.badogosShop.service.CartService;
import com.example.badogosShop.service.OrderService;
import com.example.badogosShop.service.ProductService;
import com.example.badogosShop.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@SpringBootTest
class BadogosShopApplicationTests {

	@Test
	void contextLoads() {
	}
}

@ExtendWith(MockitoExtension.class)
class CartServiceUnitTest {

	@Mock
	private CartRepository cartRepository;

	@Mock
	private ProductRepository productRepository;

	@Mock
	private UserRepository userRepository;

	@Mock
	private CartProductRepository cartProductRepository;

	@InjectMocks
	private CartService cartService;

	private User testUser;
	private Product testProduct;
	private Cart testCart;
	private CartProduct testCartProduct;

	@BeforeEach
	void setUp() {
		testUser = new User();
		testUser.setId(1);
		testUser.setEmail("test@example.com");
		testUser.setFirstName("John");
		testUser.setLastName("Doe");
		testUser.setIsDeleted(false);

		testProduct = new Product();
		testProduct.setId(1);
		testProduct.setName("TestProduct");
		testProduct.setPrice(100);
		testProduct.setAmount(10);
		testProduct.setIsDeleted(false);
		testProduct.setStockKeepingUnit("SKU123");
		testProduct.setDescription("Test Description");

		testCart = new Cart();
		testCart.setId(1);
		testCart.setCartUser(testUser);
		testCart.setCartProductList(new ArrayList<>());

		testCartProduct = new CartProduct();
		testCartProduct.setId(1);
		testCartProduct.setAmount(2);
		testCartProduct.setCartProduct(testProduct);
		testCartProduct.setCart(testCart);
	}

	@Test
	void testGetCartByUserIdSuccessful() {
		when(userRepository.findById(1)).thenReturn(Optional.of(testUser));
		when(cartRepository.getCartByUserId(1)).thenReturn(Optional.of(testCart));

		ResponseEntity<Object> response = cartService.getCartByUserId(1);

		assertEquals(HttpStatus.OK, response.getStatusCode());
		assertNotNull(response.getBody());
	}

	@Test
	void testGetCartByUserIdNotFound() {
		when(userRepository.findById(999)).thenReturn(Optional.empty());

		ResponseEntity<Object> response = cartService.getCartByUserId(999);

		assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
	}

	@Test
	void testAddProductToCartSuccessful() {
		when(cartRepository.getCartByUserId(1)).thenReturn(Optional.of(testCart));
		when(productRepository.findById(1)).thenReturn(Optional.of(testProduct));
		when(cartProductRepository.save(any(CartProduct.class))).thenReturn(testCartProduct);
		when(cartRepository.save(any(Cart.class))).thenReturn(testCart);

		ResponseEntity<Object> response = cartService.addProductToCart(1, 2, 1);

		assertEquals(HttpStatus.OK, response.getStatusCode());
	}

	@Test
	void testAddProductToCartProductNotFound() {
		when(cartRepository.getCartByUserId(1)).thenReturn(Optional.of(testCart));
		when(productRepository.findById(999)).thenReturn(Optional.empty());

		ResponseEntity<Object> response = cartService.addProductToCart(999, 2, 1);

		assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
	}

	@Test
	void testAddProductToCartInsufficientStock() {
		testProduct.setAmount(1);
		when(cartRepository.getCartByUserId(1)).thenReturn(Optional.of(testCart));
		when(productRepository.findById(1)).thenReturn(Optional.of(testProduct));

		ResponseEntity<Object> response = cartService.addProductToCart(1, 5, 1);

		assertEquals(HttpStatus.UNPROCESSABLE_ENTITY, response.getStatusCode());
	}

	@Test
	void testDeleteProductFromCartSuccessful() {
		when(cartRepository.getCartByUserId(1)).thenReturn(Optional.of(testCart));
		when(cartProductRepository.findById(1)).thenReturn(Optional.of(testCartProduct));
		doNothing().when(cartProductRepository).deleteProductFromCart(1);
		when(productRepository.save(any(Product.class))).thenReturn(testProduct);

		ResponseEntity<Object> response = cartService.deleteProductFromCart(1, 1);

		assertEquals(HttpStatus.OK, response.getStatusCode());
	}

	@Test
	void testClearCartSuccessful() {
		when(cartRepository.findById(1)).thenReturn(Optional.of(testCart));
		doNothing().when(cartRepository).clearCart(1);

		ResponseEntity<Object> response = cartService.clearCart(1);

		assertEquals(HttpStatus.OK, response.getStatusCode());
	}

	@Test
	void testClearCartNotFound() {
		when(cartRepository.findById(999)).thenReturn(Optional.empty());

		ResponseEntity<Object> response = cartService.clearCart(999);

		assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
	}
}

@ExtendWith(MockitoExtension.class)
class UserServiceUnitTest {

	@Mock
	private UserRepository userRepository;

	@Mock
	private PasswordEncoder passwordEncoder;

	@Mock
	private CartRepository cartRepository;

	@Mock
	private EmailSender emailSender;

	@InjectMocks
	private UserService userService;

	private User testUser;

	@BeforeEach
	void setUp() {
		testUser = new User();
		testUser.setId(1);
		testUser.setEmail("test@example.com");
		testUser.setPassword("encodedPassword");
		testUser.setFirstName("John");
		testUser.setLastName("Doe");
		testUser.setIsDeleted(false);
	}

	@Test
	void testLoginSuccessful() {
		when(userRepository.findByEmail("test@example.com")).thenReturn(Optional.of(testUser));
		when(passwordEncoder.matches("TestPassword1!", "encodedPassword")).thenReturn(true);
		when(userRepository.save(any(User.class))).thenReturn(testUser);

		ResponseEntity<Object> response = userService.login("test@example.com", "TestPassword1!");

		assertEquals(HttpStatus.OK, response.getStatusCode());
		assertNotNull(response.getBody());
		verify(userRepository, times(1)).save(any(User.class));
	}

	@Test
	void testLoginFailedNullEmail() {
		ResponseEntity<Object> response = userService.login(null, "TestPassword1!");

		assertEquals(HttpStatus.UNPROCESSABLE_ENTITY, response.getStatusCode());
		verify(userRepository, never()).findByEmail(any());
	}

	@Test
	void testLoginUserNotFound() {
		when(userRepository.findByEmail("notfound@example.com")).thenReturn(Optional.empty());

		ResponseEntity<Object> response = userService.login("notfound@example.com", "TestPassword1!");

		assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
	}

	@Test
	void testRegisterSuccessful() throws Exception {
		User newUser = new User();
		newUser.setEmail("new@example.com");
		newUser.setPassword("TestPassword1!");
		newUser.setFirstName("Jane");
		newUser.setLastName("Smith");

		when(passwordEncoder.encode("TestPassword1!")).thenReturn("encodedPassword");
		when(userRepository.save(any(User.class))).thenReturn(newUser);
		when(cartRepository.save(any(Cart.class))).thenReturn(new Cart());
		doNothing().when(emailSender).sendEmailAboutRegistration("new@example.com");

		ResponseEntity<Object> response = userService.register(newUser);

		assertEquals(HttpStatus.OK, response.getStatusCode());
		verify(userRepository, times(1)).save(any(User.class));
		verify(cartRepository, times(1)).save(any(Cart.class));
	}

	@Test
	void testRegisterFailedInvalidEmail() {
		User newUser = new User();
		newUser.setEmail("invalidemail");
		newUser.setPassword("TestPassword1!");

		ResponseEntity<Object> response = userService.register(newUser);

		assertEquals(HttpStatus.UNPROCESSABLE_ENTITY, response.getStatusCode());
		verify(userRepository, never()).save(any());
	}

	@Test
	void testUpdateUserSuccessful() {
		UserUpdate updateData = new UserUpdate("John", "Updated", "updated@example.com", "123456789");
		when(userRepository.findById(1)).thenReturn(Optional.of(testUser));
		when(userRepository.save(any(User.class))).thenReturn(testUser);

		ResponseEntity<Object> response = userService.update(1, updateData);

		assertEquals(HttpStatus.OK, response.getStatusCode());
		verify(userRepository, times(1)).save(any(User.class));
	}

	@Test
	void testDeleteUserSuccessful() {
		when(userRepository.findById(1)).thenReturn(Optional.of(testUser));
		doNothing().when(userRepository).deleteUserById(1);

		ResponseEntity<Object> response = userService.delete(1);

		assertEquals(HttpStatus.OK, response.getStatusCode());
		verify(userRepository, times(1)).deleteUserById(1);
	}

	@Test
	void testDeleteUserNotFound() {
		when(userRepository.findById(999)).thenReturn(Optional.empty());

		ResponseEntity<Object> response = userService.delete(999);

		assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
	}

	@Test
	void testIsEmailValidCorrect() {
		assertTrue(userService.isEmailValid("test@example.com"));
	}

	@Test
	void testIsEmailValidInvalid() {
		assertFalse(userService.isEmailValid("invalidemail"));
	}

	@Test
	void testIsPasswordValidCorrect() {
		assertTrue(userService.isPasswordValid("TestPassword1!"));
	}

	@Test
	void testIsPasswordValidTooShort() {
		assertFalse(userService.isPasswordValid("short1!"));
	}
}

@ExtendWith(MockitoExtension.class)
class ProductServiceUnitTest {

	@Mock
	private ProductRepository productRepository;

	@Mock
	private CategoryRepository categoryRepository;

	@Mock
	private BrandRepository brandRepository;

	@InjectMocks
	private ProductService productService;

	private Product testProduct;
	private Category testCategory;
	private Brand testBrand;

	@BeforeEach
	void setUp() {
		testBrand = new Brand();
		testBrand.setId(1);
		testBrand.setName("TestBrand");
		testBrand.setIsDeleted(false);

		testCategory = new Category();
		testCategory.setId(1);
		testCategory.setName("TestCategory");
		testCategory.setIsDeleted(false);

		testProduct = new Product();
		testProduct.setId(1);
		testProduct.setName("TestProduct");
		testProduct.setPrice(100);
		testProduct.setAmount(10);
		testProduct.setIsDeleted(false);
		testProduct.setCategory(testCategory);
		testProduct.setBrand(testBrand);
		testProduct.setStockKeepingUnit("SKU123");
		testProduct.setDescription("Test Description");
		testProduct.setDiscount(0);
	}

	@Test
	void testGetAllProducts() {
		List<Product> products = new ArrayList<>();
		products.add(testProduct);
		when(productRepository.findAll()).thenReturn(products);

		ResponseEntity<Object> response = productService.getAllProduct();

		assertEquals(HttpStatus.OK, response.getStatusCode());
		assertNotNull(response.getBody());
	}

	@Test
	void testGetProductByIdSuccessful() {
		when(productRepository.findById(1)).thenReturn(Optional.of(testProduct));
		when(productRepository.save(any(Product.class))).thenReturn(testProduct);

		ResponseEntity<Object> response = productService.getProductById(1);

		assertEquals(HttpStatus.OK, response.getStatusCode());
		verify(productRepository, times(1)).save(any(Product.class));
	}

	@Test
	void testGetProductByIdNotFound() {
		when(productRepository.findById(999)).thenReturn(Optional.empty());

		ResponseEntity<Object> response = productService.getProductById(999);

		assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
	}

	@Test
	void testAddProductSuccessful() {
		ProductDto productDto = new ProductDto(
			"NewProduct", 1, 50, 100,
			1.5, "plastic", 10.0, 5.0, 8.0,
			"M", false, "SKU123", "Test Description", 1
		);

		when(brandRepository.getBrandById(1)).thenReturn(Optional.of(testBrand));
		when(categoryRepository.findById(1)).thenReturn(Optional.of(testCategory));
		when(productRepository.save(any(Product.class))).thenReturn(testProduct);

		ResponseEntity<Object> response = productService.addProduct(productDto);

		assertEquals(HttpStatus.OK, response.getStatusCode());
		verify(productRepository, times(2)).save(any(Product.class));
	}

	@Test
	void testAddProductBrandNotFound() {
		ProductDto productDto = new ProductDto(
			"NewProduct", 999, 50, 100,
			1.5, "plastic", 10.0, 5.0, 8.0,
			"M", false, "SKU123", "Test Description", 1
		);

		when(brandRepository.getBrandById(999)).thenReturn(Optional.empty());

		ResponseEntity<Object> response = productService.addProduct(productDto);

		assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
	}

	@Test
	void testDeleteProductSuccessful() {
		when(productRepository.findById(1)).thenReturn(Optional.of(testProduct));
		when(productRepository.save(any(Product.class))).thenReturn(testProduct);

		ResponseEntity<Object> response = productService.deleteProduct(1);

		assertEquals(HttpStatus.OK, response.getStatusCode());
		verify(productRepository, times(1)).save(any(Product.class));
	}

	@Test
	void testDeleteProductNotFound() {
		when(productRepository.findById(999)).thenReturn(Optional.empty());

		ResponseEntity<Object> response = productService.deleteProduct(999);

		assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
	}

	@Test
	void testGetMostViewedProducts() {
		List<Product> mostViewed = new ArrayList<>();
		mostViewed.add(testProduct);
		when(productRepository.getMostViewedProducts()).thenReturn(mostViewed);

		ResponseEntity<Object> response = productService.getMostViewedProducts();

		assertEquals(HttpStatus.OK, response.getStatusCode());
	}

	@Test
	void testGetProductsByCategory() {
		List<Product> products = new ArrayList<>();
		products.add(testProduct);
		Page<Product> page = new PageImpl<>(products);

		when(categoryRepository.findById(1)).thenReturn(Optional.of(testCategory));
		when(productRepository.findByCategory(testCategory, PageRequest.of(0, 10))).thenReturn(page);

		ResponseEntity<Object> response = productService.getProductsByCategory(PageRequest.of(0, 10), 1);

		assertEquals(HttpStatus.OK, response.getStatusCode());
	}
}

@ExtendWith(MockitoExtension.class)
class OrderServiceUnitTest {

	@Mock
	private OrderHistoryRepository orderHistoryRepository;

	@Mock
	private UserRepository userRepository;

	@Mock
	private StatusRepository statusRepository;

	@Mock
	private EmailSender emailSender;

	@InjectMocks
	private OrderService orderService;

	private User testUser;
	private OrderHistory testOrder;

	@BeforeEach
	void setUp() {
		testUser = new User();
		testUser.setId(1);
		testUser.setEmail("test@example.com");
		testUser.setFirstName("John");
		testUser.setLastName("Doe");
		testUser.setIsDeleted(false);

		testOrder = new OrderHistory();
		testOrder.setId(1);
		testOrder.setOrderUser(testUser);
		testOrder.setFirstName("John");
		testOrder.setLastName("Doe");
		testOrder.setPhone("123456789");
		testOrder.setEmail("test@example.com");
		testOrder.setOrderId(1);
		testOrder.setIsCanceled(false);
	}

	@Test
	void testGetOrderHistoryByUserIdSuccessful() {
		when(userRepository.findById(1)).thenReturn(Optional.of(testUser));

		ResponseEntity<Object> response = orderService.getOrderHistoryByUserId(1);

		assertEquals(HttpStatus.OK, response.getStatusCode());
		assertNotNull(response.getBody());
	}

	@Test
	void testGetOrderHistoryByUserIdNotFound() {
		when(userRepository.findById(999)).thenReturn(Optional.empty());

		ResponseEntity<Object> response = orderService.getOrderHistoryByUserId(999);

		assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
	}

	@Test
	void testCancelOrderSuccessful() throws Exception {
		Status cancelledStatus = new Status();
		cancelledStatus.setId(3);
		cancelledStatus.setName("Cancelled");

		when(orderHistoryRepository.findById(1)).thenReturn(Optional.of(testOrder));
		when(userRepository.getUserById(1)).thenReturn(Optional.of(testUser));
		when(statusRepository.findById(3)).thenReturn(Optional.of(cancelledStatus));
		doNothing().when(emailSender).sendEmailAboutCancelledOrder("test@example.com");
		when(orderHistoryRepository.save(any(OrderHistory.class))).thenReturn(testOrder);

		ResponseEntity<Object> response = orderService.cancelOrder(1, 1);

		assertEquals(HttpStatus.OK, response.getStatusCode());
	}

	@Test
	void testCancelOrderNotFound() {
		when(orderHistoryRepository.findById(999)).thenReturn(Optional.empty());

		ResponseEntity<Object> response = orderService.cancelOrder(999, 1);

		assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
	}

	@Test
	void testGetOrderHistoryByUserIdNullId() {
		ResponseEntity<Object> response = orderService.getOrderHistoryByUserId(null);

		assertEquals(HttpStatus.UNPROCESSABLE_ENTITY, response.getStatusCode());
	}
}
